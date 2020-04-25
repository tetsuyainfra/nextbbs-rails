# desc "Explaining what the task does"
# task :nextbbs do
#   # Task goes here
# end

namespace :db do
  namespace :nextbbs do
    desc "Re-count comments."
    task fix_counts: :"db:fixtures:load" do
      Nextbbs::Comment.counter_culture_fix_counts
    end
  end
end

Rake::Task["db:fixtures:load"].enhance do
  if Rake::Task.task_defined?("app:db:nextbbs:fix_counts")
    # exec task on Mountable engine dir
    Rake::Task["app:db:nextbbs:fix_counts"].execute
  elsif Rake::Task.task_defined?("db:nextbbs:fix_counts")
    # exec task on dummy engine dir
    Rake::Task["db:nextbbs:fix_counts"].execute
  end
end