#
# Author:: Noah Kantrowitz <noah@coderanger.net>
#
# Copyright 2014, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

candidates = node['recipes'] \
  .select {|r| r.start_with?('role-env-demo') } \
  .map {|r| r = r['role-env-demo::'.length..-1] || node.chef_environment}
raise "More than one candidate environment found: #{candidates.join(', ')}" if candidates.size > 1

default['app_environment'] = candidates.first

default['role-env-demo']['iama'] = ''
