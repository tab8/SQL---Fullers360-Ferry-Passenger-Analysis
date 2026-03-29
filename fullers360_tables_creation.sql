-- ============================================================
-- TABLE 1: vessels
-- Stores information about each ferry vessel in the fleet
-- ============================================================
CREATE TABLE vessels (
    vessel_id       INT             NOT NULL AUTO_INCREMENT,
    vessel_name     VARCHAR(50)     NOT NULL,
    vessel_type     VARCHAR(50)     NOT NULL,
    capacity        INT             NOT NULL,
    is_active       TINYINT(1)      NOT NULL DEFAULT 1,
    commissioned_year YEAR          NOT NULL,

    -- Constraints
    CONSTRAINT pk_vessels
        PRIMARY KEY (vessel_id),
    CONSTRAINT uq_vessel_name
        UNIQUE (vessel_name),
    CONSTRAINT chk_capacity
        CHECK (capacity > 0),
    CONSTRAINT chk_vessel_type
        CHECK (vessel_type IN ('Fast Ferry', 'Catamaran', 'Passenger Ferry', 'Cruise Vessel'))
);

-- ============================================================
-- TABLE 2: routes
-- Stores information about each ferry route
-- ============================================================
CREATE TABLE routes (
    route_id            INT             NOT NULL AUTO_INCREMENT,
    route_name          VARCHAR(100)    NOT NULL,
    origin              VARCHAR(50)     NOT NULL,
    destination         VARCHAR(50)     NOT NULL,
    frequency_mins      INT             NULL COMMENT 'Departure frequency in minutes. NULL = irregular schedule',
    is_weekend_only     TINYINT(1)      NOT NULL DEFAULT 0,
    is_summer_only      TINYINT(1)      NOT NULL DEFAULT 0,
    distance_km         DECIMAL(5,2)    NOT NULL,
    duration_mins       INT             NOT NULL COMMENT 'Approximate travel time in minutes',
    is_active           TINYINT(1)      NOT NULL DEFAULT 1,

    -- Constraints
    CONSTRAINT pk_routes
        PRIMARY KEY (route_id),
    CONSTRAINT uq_route_name
        UNIQUE (route_name),
    CONSTRAINT chk_frequency
        CHECK (frequency_mins IS NULL OR frequency_mins > 0),
    CONSTRAINT chk_distance
        CHECK (distance_km > 0),
    CONSTRAINT chk_duration
        CHECK (duration_mins > 0),
    CONSTRAINT chk_origin_destination
        CHECK (origin <> destination)
);

-- ============================================================
-- TABLE 3: passenger_records
-- Stores daily passenger count records per route and vessel
-- ============================================================
CREATE TABLE passenger_records (
    record_id           INT             NOT NULL AUTO_INCREMENT,
    travel_date         DATE            NOT NULL,
    route_id            INT             NOT NULL,
    vessel_id           INT             NOT NULL,
    passenger_count     INT             NOT NULL,
    daily_trips         INT             NOT NULL,
    season              VARCHAR(10)     NOT NULL,
    is_weekend          TINYINT(1)      NOT NULL DEFAULT 0,
    recorded_at         TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT pk_passenger_records
        PRIMARY KEY (record_id),
    CONSTRAINT uq_daily_record
        UNIQUE (travel_date, route_id, vessel_id),
    CONSTRAINT chk_passenger_count
        CHECK (passenger_count >= 0),
    CONSTRAINT chk_daily_trips
        CHECK (daily_trips > 0),
    CONSTRAINT chk_season
        CHECK (season IN ('Peak', 'Shoulder', 'Off-Peak')),

    -- Foreign Keys
    CONSTRAINT fk_route
        FOREIGN KEY (route_id)
        REFERENCES routes (route_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT fk_vessel
        FOREIGN KEY (vessel_id)
        REFERENCES vessels (vessel_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    -- Index for common query patterns
    INDEX idx_travel_date (travel_date),
    INDEX idx_route_date (route_id, travel_date),
    INDEX idx_vessel_date (vessel_id, travel_date),
    INDEX idx_season (season)
);