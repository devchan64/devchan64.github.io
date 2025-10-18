-- obs_seg_kor_royshil_min.lua
-- ✅ Flatpak OBS
-- ✅ royshil/obs-backgroundremoval 플러그인 전용 (type = background_removal)
-- ✅ UI 필터명 = "배경 제거"
-- ✅ 감지 실패 시 → 에러로 중단(STRICT)
-- ✅ 배경 추가(Color Source) 없음: 순수 배경제거만 적용
-- ✅ 불필요한 버튼 제거(디버그/강제전환/토글 삭제) → 최소 UI: 소스 새로고침, 필터 적용

local obs = obslua

-- ===== 상태 저장 =====
local selected_source = ""
local video_only = true

-- royshil 전용 타입 ID (이것만 사용)
local BR_FILTER_TYPE = "background_removal"
local BR_FILTER_UI_NAME = "배경 제거" -- OBS UI 필터 표시용 (한글 그대로)

local info_text = ""

-- ===== 기본 유틸 =====
local function enum_sources(filter_video)
    local list = {}
    local arr = obs.obs_enum_sources()
    if arr ~= nil then
        for _, src in ipairs(arr) do
            local name = obs.obs_source_get_name(src)
            local flags = obs.obs_source_get_output_flags(src)
            local is_video = (bit.band(flags, obs.OBS_SOURCE_VIDEO) ~= 0)
            if (not filter_video) or is_video then
                table.insert(list, name)
            end
        end
        obs.source_list_release(arr)
    end
    table.sort(list)
    return list
end

local function populate_source_list(prop)
    obs.obs_property_list_clear(prop)
    local items = enum_sources(video_only)
    for _, name in ipairs(items) do
        obs.obs_property_list_add_string(prop, name, name)
    end
end

local function get_source(name)
    if not name or name == "" then return nil end
    return obs.obs_get_source_by_name(name)
end

local function get_filter(source, name)
    if source == nil then return nil end
    return obs.obs_source_get_filter_by_name(source, name)
end

local function create_or_update_filter(source, type_id, fname, kv, replace_existing)
    if source == nil then error("[FAIL] create_or_update_filter: source is nil") end
    local settings = obs.obs_data_create()
    for k, v in pairs(kv or {}) do
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
        obs.obs_data_release(settings)
        return existing
    else
        local f = obs.obs_source_create(type_id, fname, settings, nil)
        obs.obs_data_release(settings)
        if f ~= nil then
            obs.obs_source_filter_add(source, f)
            return f
        end
    end
    return nil
end

local function move_filter_to_top(source, filter)
    if source == nil or filter == nil then return end
    local ok_set = pcall(function()
        obs.obs_source_set_filter_order(source, filter, 0)
    end)
    if ok_set then return end
    pcall(function()
        for _ = 1, 32 do
            obs.obs_source_filter_set_order(source, filter, obs.OBS_ORDER_MOVE_UP)
        end
    end)
end

-- ===== 플러그인 감지 (엄격) =====
local function detect_background_removal()
    local dummy = obs.obs_source_create_private("color_source", "__dummy__", nil)
    if dummy == nil then return false end

    local settings = obs.obs_data_create()
    local f = obs.obs_source_create(BR_FILTER_TYPE, "__probe__", settings, nil)
    obs.obs_data_release(settings)

    local ok = false
    if f ~= nil then
        obs.obs_source_filter_add(dummy, f)
        obs.obs_source_release(f)
        ok = true
        local probe_filter = obs.obs_source_get_filter_by_name(dummy, "__probe__")
        if probe_filter ~= nil then
            obs.obs_source_filter_remove(dummy, probe_filter)
            obs.obs_source_release(probe_filter)
        end
    end

    obs.obs_source_release(dummy)
    return ok
end

local function update_info_text(plugin_ok)
    if plugin_ok then
        info_text = "✅ obs-backgroundremoval 필터 감지됨 (type: background_removal)"
    else
        info_text = [[
❌ obs-backgroundremoval(royshil) 플러그인이 감지되지 않았습니다.
설치 후 OBS를 재시작하세요.
• Flatpak:
  flatpak install flathub com.obsproject.Studio.Plugin.BackgroundRemoval
📌 감지 실패 시 아무 필터도 적용하지 않습니다.
]]
    end
end

-- ===== 최종 적용 흐름 =====
local function apply_filters()
    local src = get_source(selected_source)
    if src == nil then
        error("[FAIL] 소스를 찾을 수 없습니다: " .. tostring(selected_source))
    end

    local ok = detect_background_removal()
    update_info_text(ok)
    if not ok then
        obs.obs_source_release(src)
        error("[STOP] 배경제거 플러그인이 감지되지 않았습니다. 설치 후 다시 시도하세요.")
    end

    -- 1) 배경 제거 필터 추가/업데이트 (순수 배경제거만 수행)
    local br_settings = {
        -- ✅ GPU 강제: 실제 우선키(useGPU) = cuda, advanced 유지
        useGPU                  = "cuda",
        advanced                = true,
        inference_device_id     = { int = 1 },  -- 보조 ENUM

        -- ✅ 고정 요청 값 유지
        enable_threshold        = true,
        threshold               = 0.53,
        contour                 = 0.18,
        smooth_contour          = 0.15,
        feather                 = 0.15,
        mask_every_x_frames     = 1,
        enable_focal_blur       = false,
        enable_image_similarity = false,
        disabled                = true
    }

    local br = create_or_update_filter(src, BR_FILTER_TYPE, BR_FILTER_UI_NAME, br_settings, true)
    if br ~= nil then
        -- 필터 실제 활성화(이번 적용에 한해): disabled=false로 덮어써 동작 보장
        pcall(function() obs.obs_source_set_enabled(br, true) end)
        local s2 = obs.obs_source_get_settings(br)
        obs.obs_data_set_string(s2, "useGPU", "cuda")
        obs.obs_data_set_int(s2, "inference_device_id", 1)
        obs.obs_data_set_bool(s2, "disabled", false) -- 적용 직후 1회만 강제 On
        obs.obs_source_update(br, s2)
        obs.obs_data_release(s2)

        move_filter_to_top(src, br)
    else
        obs.obs_source_release(src)
        error("[FAIL] '배경 제거' 필터 생성/업데이트 실패")
    end

    obs.script_log(obs.LOG_INFO, "[OK] 배경 제거 적용 완료 (CUDA)")
    obs.obs_source_release(src)
end

-- ===== OBS Script UI 구성 =====
local source_list_prop
local info_prop

local function refresh_sources(props)
    populate_source_list(source_list_prop)
    return true
end

local function refresh_plugin_info(props)
    local ok = detect_background_removal()
    update_info_text(ok)
    if info_prop ~= nil then
        obs.obs_property_set_long_description(info_prop, info_text)
    end
    obs.script_log(obs.LOG_INFO, "[CHECK] " .. info_text)
    return true
end

function script_description()
    return [[
royshil/obs-backgroundremoval 전용 자동 필터 스크립트 (미니멀)
- 감지 성공 시: "배경 제거" 필터만 적용 (GPU=CUDA 강제)
- 플러그인 미감지 시: 에러로 중단(STRICT)
- 소스는 드롭다운으로 정확히 선택
]]
end

function script_properties()
    local props = obs.obs_properties_create()

    source_list_prop = obs.obs_properties_add_list(
        props, "selected_source", "대상 비디오 소스",
        obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING
    )
    populate_source_list(source_list_prop)
    obs.obs_properties_add_bool(props, "video_only", "비디오 소스만 표시")

    info_prop = obs.obs_properties_add_text(
        props, "info", "상태/안내", obs.OBS_TEXT_INFO
    )
    obs.obs_property_set_long_description(info_prop, info_text)

    -- ✅ 최소 버튼만 유지
    obs.obs_properties_add_button(props, "refresh_sources", "소스 목록 새로고침", function() return refresh_sources(props) end)
    obs.obs_properties_add_button(props, "apply_btn", "필터 적용", function() apply_filters(); return true end)

    return props
end

function script_defaults(settings)
    obs.obs_data_set_default_bool(settings, "video_only", true)
end

function script_update(settings)
    selected_source = obs.obs_data_get_string(settings, "selected_source")
    video_only      = obs.obs_data_get_bool(settings, "video_only")
    local ok = detect_background_removal()
    update_info_text(ok)
end

function script_load(settings)
    local ok = detect_background_removal()
    update_info_text(ok)
end
