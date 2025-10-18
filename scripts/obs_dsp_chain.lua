-- obs_dsp_chain_dropdown.lua
-- 드롭다운에서 오디오 소스를 골라 Noise Gate → RNNoise → Compressor → Limiter 자동 적용

local obs = obslua

-- ===== 설정 상태 =====
local selected_source = ""  -- 드롭다운에서 선택된 소스 이름(문자열)
local audio_only = true     -- 오디오 출력 있는 소스만 나열 (권장)

-- Gate
local gate_open = -45.0
local gate_close = -48.0
local gate_attack = 5
local gate_hold = 20
local gate_release = 100

-- RNNoise
local use_rnnoise = true   -- true면 RNNoise 적용
-- 주의: OBS 버전에 따라 method 값이 2가 아닐 수 있음

-- Compressor
local comp_threshold = -20.0
local comp_ratio = 3.0
local comp_attack = 10
local comp_release = 120
local comp_output_gain = 4.0

-- Limiter
local limit_threshold = -3.0
local limit_release = 100

-- ===== 유틸 =====
local function enum_sources(filter_audio)
  local sources = {}
  local arr = obs.obs_enum_sources()
  if arr ~= nil then
    for _, src in ipairs(arr) do
      local name = obs.obs_source_get_name(src)
      local flags = obs.obs_source_get_output_flags(src)
      local is_audio = (bit.band(flags, obs.OBS_SOURCE_AUDIO) ~= 0)
      if (not filter_audio) or is_audio then
        table.insert(sources, name)
      end
    end
    obs.source_list_release(arr)
  end
  table.sort(sources)
  return sources
end

local function populate_source_list(prop, filter_audio)
  obs.obs_property_list_clear(prop)
  local items = enum_sources(filter_audio)
  for _, name in ipairs(items) do
    obs.obs_property_list_add_string(prop, name, name)
  end
end

local function get_source(name)
  if not name or name == "" then return nil end
  return obs.obs_get_source_by_name(name)
end

local function get_filter(source, filter_name)
  if source == nil then return nil end
  return obs.obs_source_get_filter_by_name(source, filter_name)
end

local function create_or_update_filter(source, ft, fname, settings_table)
  if source == nil then return end
  local settings = obs.obs_data_create()
  for k, v in pairs(settings_table) do
    local t = type(v)
    if     t == "number"  then obs.obs_data_set_double(settings, k, v)
    elseif t == "boolean" then obs.obs_data_set_bool(settings, k, v)
    elseif t == "string"  then obs.obs_data_set_string(settings, k, v)
    elseif t == "table" and v.int ~= nil then
      obs.obs_data_set_int(settings, k, v.int)
    end
  end
  local existing = get_filter(source, fname)
  if existing ~= nil then
    obs.obs_source_update(existing, settings)
    obs.obs_source_release(existing)
  else
    local newf = obs.obs_source_create(ft, fname, settings, nil)
    if newf ~= nil then
      obs.obs_source_filter_add(source, newf)
      obs.obs_source_release(newf)
    end
  end
  obs.obs_data_release(settings)
end

local function apply_chain()
  local src = get_source(selected_source)
  if src == nil then error("소스를 찾을 수 없습니다: " .. tostring(selected_source)) end

  -- 1) Noise Gate
  create_or_update_filter(src, "noise_gate_filter", "Noise Gate (Auto)", {
    open_threshold  = gate_open,
    close_threshold = gate_close,
    attack_time     = gate_attack,
    hold_time       = gate_hold,
    release_time    = gate_release
  })

  -- 2) RNNoise
  if use_rnnoise then
    create_or_update_filter(src, "noise_suppress_filter", "Noise Suppression (RNNoise)", {
      method = { int = 2 }  -- 안 되면 1/0 테스트
    })
  end

  -- 3) Compressor
  create_or_update_filter(src, "compressor_filter", "Compressor (Soft Knee)", {
    ratio        = comp_ratio,
    threshold    = comp_threshold,
    attack_time  = comp_attack,
    release_time = comp_release,
    output_gain  = comp_output_gain
  })

  -- 4) Limiter
  create_or_update_filter(src, "limiter_filter", "Limiter (Ceiling -3dB)", {
    threshold    = limit_threshold,
    release_time = limit_release
  })

  obs.obs_source_release(src)
end

-- ===== OBS Hooks =====
local source_list_prop = nil

local function refresh_sources(props)
  populate_source_list(source_list_prop, audio_only)
  return true
end

function script_description()
  return [[
드롭다운에서 오디오 소스를 선택해 필터 체인(Noise Gate → RNNoise → Compressor → Limiter)을 자동 적용합니다.
]]
end

function script_properties()
  local props = obs.obs_properties_create()

  source_list_prop = obs.obs_properties_add_list(
    props, "selected_source", "대상 오디오 소스",
    obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING
  )
  populate_source_list(source_list_prop, audio_only)

  obs.obs_properties_add_bool(props, "audio_only", "오디오 소스만 표시")

  -- Gate
  obs.obs_properties_add_float(props, "gate_open",  "Gate Open (dB)",  -80.0, 0.0, 0.5)
  obs.obs_properties_add_float(props, "gate_close", "Gate Close (dB)", -80.0, 0.0, 0.5)
  obs.obs_properties_add_int(props,   "gate_attack","Gate Attack (ms)", 0, 200, 1)
  obs.obs_properties_add_int(props,   "gate_hold",  "Gate Hold (ms)",   0, 500, 1)
  obs.obs_properties_add_int(props,   "gate_release","Gate Release (ms)",0, 500, 1)

  -- RNNoise
  obs.obs_properties_add_bool(props, "use_rnnoise", "RNNoise 사용")

  -- Compressor
  obs.obs_properties_add_float(props, "comp_threshold", "Comp Threshold (dB)", -60.0, 0.0, 0.5)
  obs.obs_properties_add_float(props, "comp_ratio",     "Comp Ratio", 1.0, 20.0, 0.1)
  obs.obs_properties_add_int(props,   "comp_attack",    "Comp Attack (ms)", 0, 200, 1)
  obs.obs_properties_add_int(props,   "comp_release",   "Comp Release (ms)",0, 500, 1)
  obs.obs_properties_add_float(props, "comp_output_gain","Comp Output Gain (dB)", -24.0, 24.0, 0.5)

  -- Limiter
  obs.obs_properties_add_float(props, "limit_threshold", "Limiter Threshold (dB)", -24.0, 0.0, 0.5)
  obs.obs_properties_add_int(props,   "limit_release",   "Limiter Release (ms)", 0, 500, 1)

  obs.obs_properties_add_button(props, "refresh_btn", "소스 목록 새로고침", function() return refresh_sources(props) end)
  obs.obs_properties_add_button(props, "apply_btn", "필터 체인 적용", function() apply_chain(); return true end)

  return props
end

function script_defaults(settings)
  obs.obs_data_set_default_bool(settings, "audio_only", true)

  obs.obs_data_set_default_double(settings, "gate_open",  -45.0)
  obs.obs_data_set_default_double(settings, "gate_close", -48.0)
  obs.obs_data_set_default_int(settings,    "gate_attack", 5)
  obs.obs_data_set_default_int(settings,    "gate_hold",   20)
  obs.obs_data_set_default_int(settings,    "gate_release",100)

  obs.obs_data_set_default_bool(settings,   "use_rnnoise", true)

  obs.obs_data_set_default_double(settings, "comp_threshold", -20.0)
  obs.obs_data_set_default_double(settings, "comp_ratio",      3.0)
  obs.obs_data_set_default_int(settings,    "comp_attack",     10)
  obs.obs_data_set_default_int(settings,    "comp_release",    120)
  obs.obs_data_set_default_double(settings, "comp_output_gain", 4.0)

  obs.obs_data_set_default_double(settings, "limit_threshold", -3.0)
  obs.obs_data_set_default_int(settings,    "limit_release",   100)
end

function script_update(settings)
  selected_source = obs.obs_data_get_string(settings, "selected_source")
  audio_only      = obs.obs_data_get_bool(settings, "audio_only")

  gate_open       = obs.obs_data_get_double(settings, "gate_open")
  gate_close      = obs.obs_data_get_double(settings, "gate_close")
  gate_attack     = obs.obs_data_get_int(settings,    "gate_attack")
  gate_hold       = obs.obs_data_get_int(settings,    "gate_hold")
  gate_release    = obs.obs_data_get_int(settings,    "gate_release")

  use_rnnoise     = obs.obs_data_get_bool(settings,   "use_rnnoise")

  comp_threshold  = obs.obs_data_get_double(settings, "comp_threshold")
  comp_ratio      = obs.obs_data_get_double(settings, "comp_ratio")
  comp_attack     = obs.obs_data_get_int(settings,    "comp_attack")
  comp_release    = obs.obs_data_get_int(settings,    "comp_release")
  comp_output_gain= obs.obs_data_get_double(settings, "comp_output_gain")

  limit_threshold = obs.obs_data_get_double(settings, "limit_threshold")
  limit_release   = obs.obs_data_get_int(settings,    "limit_release")
end
