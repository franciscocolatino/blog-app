if Rails.env.production? || Rails.env.staging?
  uri = ENV['REDIS_URL'] || 'redis://localhost:6379/'

  Sidekiq.configure_server do |config|
    config.redis = {
      url: uri,
      ssl_params: {
        verify_mode: OpenSSL::SSL::VERIFY_NONE
      }
    }

    database_url = ENV['DATABASE_URL']

    if database_url
      ENV['DATABASE_URL'] = "#{database_url}?pool=25"
      ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
    end
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      url: uri,
      ssl_params: {
        verify_mode: OpenSSL::SSL::VERIFY_NONE
      }
    }
  end
end

if Rails.env.development?
  uri = ENV['REDIS_URL'] || 'redis://localhost:6379/'

  Sidekiq.configure_server do |config|
    if ENV['REDIS_HOST'].present?
      config.redis = {
        host: ENV['REDIS_HOST'],
        port: ENV['REDIS_PORT'] || '6379'
      }
    else
      config.redis = {
        url: uri,
        ssl_params: {
          verify_mode: OpenSSL::SSL::VERIFY_NONE
        }
      }
    end
  end

  Sidekiq.configure_client do |config|
    if ENV['REDIS_HOST'].present?
      config.redis = {
        host: ENV['REDIS_HOST'],
        port: ENV['REDIS_PORT'] || '6379'
      }
    else
      config.redis = {
        url: uri,
        ssl_params: {
          verify_mode: OpenSSL::SSL::VERIFY_NONE
        }
      }
    end
  end
end
