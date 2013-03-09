# encoding: utf-8

require 'json'
require 'active_support/core_ext'

module UpdateTextBuilder
  PADRINO_ROOT = File.expand_path('../..', __FILE__) unless defined?(PADRINO_ROOT)

  extend self

  def build(pref_id, area_id, next_update = false)
    json = JSON.parse(File.open(json_of[pref_id]).read)

    pref_name = json['pref']
    area_data = json['areas'][area_id]

    area_name = area_data['area']

    data =
      case next_update
      when true
        area_data['data'][1]
      else
        area_data['data'][0]
      end

    status =
      %Q(
        #{data['date']} #{pref_name} #{area_name} #{data['description']},
        最高:#{data['temps']['max']}度, 最低:#{data['temps']['min']}度,
        降水確率:00-06時:#{data['rains'][0]}%, 06-12時:#{data['rains'][1]}%,
        12-18時:#{data['rains'][2]}%, 18-24時:#{data['rains'][3]}%
      ).squish
  end

  def build_for(username, pref_id, area_id, next_update = false)
    status = "@#{username} #{build(pref_id, area_id, next_update)}".truncate(140)
  end


  private
    def jsons_dir
      @dir ||= File.join(PADRINO_ROOT, 'tasks', 'data', 'jsons')
    end

    def json_of
      @jsons ||= Dir.glob("#{jsons_dir}/*.json").sort { |a, b|
        a.match(/(\d+)/)[1].to_i - b.match(/(\d+)/)[1].to_i
      }
    end
end
