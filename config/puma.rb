workers Integer(ENV.fetch('WEB_CONCURRENCY', 2))
threads_count = Integer(ENV.fetch('RAILS_MAX_THREADS', 5))
threads threads_count, threads_count

preload_app!

bind "tcp://0.0.0.0:#{ENV.fetch('PORT', 9292)}"
environment ENV.fetch('RACK_ENV', 'development')
