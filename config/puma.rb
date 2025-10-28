workers Integer(ENV.fetch('WEB_CONCURRENCY', 2))
threads_count = Integer(ENV.fetch('RAILS_MAX_THREADS', 5))
threads threads_count, threads_count

preload_app!

port ENV.fetch('PORT', 9292)
environment ENV.fetch('RACK_ENV', 'development')

on_worker_boot do
end
