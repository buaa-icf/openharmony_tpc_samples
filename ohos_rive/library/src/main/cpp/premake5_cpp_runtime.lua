--[[
 * Copyright (C) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
]]
-- It is invoked by CMakeLists.txt in the same directory.
-- RIVE_RUNTIME_DIR should be provided via the environment by CMake
local path = require('path')
local rive_runtime_dir = os.getenv('RIVE_RUNTIME_DIR')

-- Build the Rive Renderer
dofile(path.join(rive_runtime_dir, 'renderer/premake5_pls_renderer.lua'))
-- Build the Rive C++ Runtime
dofile(path.join(rive_runtime_dir, 'premake5_v2.lua'))

-- 整合鸿蒙平台需要的所有库（不包含渲染器）
project('rive_cpp_runtime')
do
    kind('StaticLib')
    files({ 'src/helpers/version.cpp' })
    links({
        'rive',
        'rive_pls_renderer',
        'rive_harfbuzz',
        'rive_sheenbidi',
        'rive_yoga',
        'miniaudio',
    })
end