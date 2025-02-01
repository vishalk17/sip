-- Create database if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'freeswitch') THEN
        CREATE DATABASE freeswitch;
    END IF;
END
$$;

-- Create user if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'freeswitch') THEN
        CREATE USER freeswitch WITH PASSWORD 'freeswitch@vishalk17';
    END IF;
END
$$;

-- Grant privileges (this is idempotent)
GRANT ALL PRIVILEGES ON DATABASE freeswitch TO freeswitch;
