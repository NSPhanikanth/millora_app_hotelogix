#!/usr/bin/env puma

directory '/home/millora/millora_app_hotelogix'
rackup "/home/millora/millora_app_hotelogix/config.ru"
environment 'development'

tag ''

pidfile "/home/millora/millora_app_hotelogix/tmp/pids/puma.pid"
state_path "/home/millora/millora_app_hotelogix/tmp/pids/puma.state"
stdout_redirect '/home/millora/millora_app_hotelogix/log/puma.error.log', '/home/millora/millora_app_hotelogix/log/puma.access.log', true

threads 0,8

# bind 'unix:///home/millora/millora_app_hotelogix/tmp/sockets/miclient-millora-puma.sock'

port 3000

workers 0

preload_app!

worker_timeout 60

prune_bundler

on_restart do
  puts 'Refreshing Gemfile'
  ENV["BUNDLE_GEMFILE"] = ""
end