-- Enable necessary extensions (if not already enabled)
-- UUID-OSSP is required for generating UUIDs if you plan to generate them within PostgreSQL
-- Uncomment the following line if you need to generate UUIDs within the database
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. Create the 'message' table
CREATE TABLE message (
    id SERIAL PRIMARY KEY,
    conversation_id UUID NOT NULL,
    message_id VARCHAR(255) UNIQUE NOT NULL,
    thread_id UUID,
    sender VARCHAR(255) NOT NULL,
    reply_to VARCHAR(255),
    recipient_to TEXT[] NOT NULL,
    recipient_cc TEXT[],
    subject VARCHAR(255),
    message_body TEXT,
    summary TEXT,
    category VARCHAR(100),
    priority INTEGER DEFAULT 3,
    email_type VARCHAR(50),
    is_read BOOLEAN DEFAULT FALSE,
    is_replied BOOLEAN DEFAULT FALSE,
    is_draft BOOLEAN DEFAULT FALSE,
    recipient_role BOOLEAN DEFAULT FALSE,
    attachments JSONB,
    labels TEXT[],
    metadata JSONB,
    source VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    deleted BOOLEAN DEFAULT FALSE
);

-- 2. Add Comments to Each Column
COMMENT ON COLUMN message.id IS 'Primary key, auto-incrementing unique identifier for each message.';
COMMENT ON COLUMN message.conversation_id IS 'UUID that uniquely identifies a conversation thread.';
COMMENT ON COLUMN message.message_id IS 'Unique identifier for each message to prevent duplicates.';
COMMENT ON COLUMN message.thread_id IS 'UUID linking messages that are part of the same thread.';
COMMENT ON COLUMN message.sender IS 'Email address of the sender.';
COMMENT ON COLUMN message.reply_to IS 'Email address to which replies should be sent, if different from sender.';
COMMENT ON COLUMN message.recipient_to IS 'Array of primary recipient email addresses.';
COMMENT ON COLUMN message.recipient_cc IS 'Array of CC (carbon copy) recipient email addresses.';
COMMENT ON COLUMN message.subject IS 'Subject line of the message.';
COMMENT ON COLUMN message.message_body IS 'Full body content of the message.';
COMMENT ON COLUMN message.summary IS 'Brief summary or snippet of the message content.';
COMMENT ON COLUMN message.category IS 'Category of the message (e.g., Work, Personal).';
COMMENT ON COLUMN message.priority IS 'Priority level of the message; higher numbers indicate lower priority.';
COMMENT ON COLUMN message.email_type IS 'Type of message (e.g., inbound, outbound).';
COMMENT ON COLUMN message.is_read IS 'Flag indicating whether the message has been read.';
COMMENT ON COLUMN message.is_replied IS 'Flag indicating whether a reply has been sent.';
COMMENT ON COLUMN message.is_draft IS 'Flag indicating if the message is a draft.';
COMMENT ON COLUMN message.recipient_role IS 'Indicates if the user is in the TO or CC fields.';
COMMENT ON COLUMN message.attachments IS 'JSONB array containing details of file attachments.';
COMMENT ON COLUMN message.labels IS 'Array of labels or tags associated with the message for categorization.';
COMMENT ON COLUMN message.metadata IS 'JSONB field for storing additional structured data relevant to AI processing.';
COMMENT ON COLUMN message.source IS 'Source of the message (e.g., web, mobile application).';
COMMENT ON COLUMN message.created_at IS 'Timestamp when the message was created.';
COMMENT ON COLUMN message.last_updated IS 'Timestamp when the message record was last updated.';
COMMENT ON COLUMN message.deleted IS 'Flag indicating if the message has been marked as deleted.';

-- 3. Create Indexes for Enhanced Query Performance
CREATE INDEX idx_message_conversation_id ON message (conversation_id);
CREATE INDEX idx_message_sender ON message (sender);
CREATE INDEX idx_message_thread_id ON message (thread_id);
CREATE INDEX idx_message_recipient_to ON message USING GIN (recipient_to);
CREATE INDEX idx_message_recipient_cc ON message USING GIN (recipient_cc);
CREATE INDEX idx_message_labels ON message USING GIN (labels);

-- 4. Create a Trigger to Automatically Update 'last_updated' Timestamp
CREATE OR REPLACE FUNCTION update_last_updated_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.last_updated = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_last_updated
BEFORE UPDATE ON message
FOR EACH ROW
EXECUTE FUNCTION update_last_updated_column();

-- 5. Optional: Create a Separate 'attachments' Table for Handling File Attachments
CREATE TABLE attachments (
    id SERIAL PRIMARY KEY,
    message_id INTEGER REFERENCES message(id) ON DELETE CASCADE,
    filename VARCHAR(255) NOT NULL,
    url TEXT NOT NULL,
    uploaded_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add an Index on 'message_id' for Faster Joins in 'attachments' Table
CREATE INDEX idx_attachments_message_id ON attachments (message_id);
