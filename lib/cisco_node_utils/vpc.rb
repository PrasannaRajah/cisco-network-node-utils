
# David Chuck, November 2015
#
# Copyright (c) 2014-2015 Cisco and/or its affiliates.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative 'node_util'
require_relative 'interface'

# Add vpc-specific constants to Cisco namespace
module Cisco
  # Vpc - node utility class for VTP configuration management
  class Vpc < NodeUtil
    attr_reader :domain
    # Constructor for Vpc
    def initialize(domain_id, instantiate=true)
      fail TypeError unless domain_id.is_a?(Integer)
      @domain = domain_id
      @set_params = {}

      create if instantiate
    end

    def self.domains
      hash = {}
      my_domain = config_get('vpc', 'domain')
      hash[my_domain] = Vpc.new(my_domain, false) unless my_domain.nil?
      hash
    end

    def self.enabled
      config_get('vpc', 'feature')
    end

    def create
      enable unless Vpc.enabled
      config_set('vpc', 'domain', state: '', domain: @domain)
    end

    def destroy
      config_set('vpc', 'feature', state: 'no')
    end

    def enable
      config_set('vpc', 'feature', state: '')
    end

    ########################################################
    #                      PROPERTIES                      #
    ########################################################
  end
end
