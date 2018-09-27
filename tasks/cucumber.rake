require 'cucumber'
require 'cucumber/rake/task'

opts =
  if ENV['CUCUMBER_RERUN_FAILED']
    [
      '@rerun.txt',
      '-r features',
      "-f junit -o ./#{Howitzer.log_dir}",
      '-f pretty'
    ].join(' ').freeze
  else
    [
      '-r features',
      '-v',
      '-x',
      "-f junit -o ./#{Howitzer.log_dir}",
      '-f rerun -o rerun.txt',
      '-f pretty'
    ].join(' ').freeze
  end

Cucumber::Rake::Task.new(:cucumber, 'Run all cucumber scenarios') do |t|
  Howitzer.current_rake_task = t.instance_variable_get :@task_name
  t.fork = false
  t.cucumber_opts = opts
end

Cucumber::Rake::Task.new(:features, 'Run all workable scenarios') do |t|
  Howitzer.current_rake_task = t.instance_variable_get :@task_name
  t.fork = false
  t.cucumber_opts = "#{opts} --tags ~@wip --tags ~@bug"
end

namespace :features do
  test_dir = ENV['CUCUMBER_RERUN_FAILED'] ? nil : 'features'
  {
    all: '--tags ~@wip --tags ~@bug',
    bvt: '--tags @bvt --tags ~@wip --tags ~@bug',
    p1:  '--tags @p1 --tags ~@wip --tags ~@bug',
    p2:  '--tags @p2 --tags ~@wip --tags ~@bug',
    wip: '--tags @wip --tags ~@bug',
    bug: '--tags @bug'
  }.each do |task_name, tags|
    Cucumber::Rake::Task.new(task_name, "Run #{task_name} scenarios") do |t|
      Howitzer.current_rake_task = t.instance_variable_get :@task_name
      t.fork = false
      t.cucumber_opts = "#{opts} #{ENV['CUCUMBER_RERUN_FAILED'] ? nil : tags} #{test_dir}"
    end
  end
end

task default: :features
