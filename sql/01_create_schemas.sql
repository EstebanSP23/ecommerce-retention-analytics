-- ============================================================
-- 01_create_schemas.sql
-- Purpose: Create logical data layers for the analytics pipeline
-- Layers:
--   raw      → Source data (no transformations)
--   staging  → Cleaned & typed data
--   mart     → Business-ready dimensional model
-- ============================================================

CREATE SCHEMA IF NOT EXISTS raw;

CREATE SCHEMA IF NOT EXISTS staging;

CREATE SCHEMA IF NOT EXISTS mart;
