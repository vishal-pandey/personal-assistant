-- 1. Create the 'conversation' table
CREATE TABLE conversation (
    id SERIAL PRIMARY KEY,
    conversation_id UUID NOT NULL UNIQUE,
    last_message_id INTEGER,
    subject VARCHAR(255),
    category VARCHAR(100),
    priority INTEGER DEFAULT 3,
    priority_level VARCHAR(50),
    is_replied BOOLEAN DEFAULT FALSE,
    recipient_to TEXT[] NOT NULL,
    recipient_cc TEXT[],
    participants TEXT[] NOT NULL,
    tags TEXT[],
    status VARCHAR(50) DEFAULT 'Active',
    last_activity_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. Add Comments to Each Column
COMMENT ON COLUMN conversation.id IS 'Primary key, auto-incrementing unique identifier for each conversation.';
COMMENT ON COLUMN conversation.conversation_id IS 'UUID that uniquely identifies a conversation.';
COMMENT ON COLUMN conversation.last_message_id IS 'Identifier referencing the last message in the conversation.';
COMMENT ON COLUMN conversation.subject IS 'Subject line of the conversation.';
COMMENT ON COLUMN conversation.category IS 'Category of the conversation (e.g., Work, Personal).';
COMMENT ON COLUMN conversation.priority IS 'Priority level of the conversation; higher numbers indicate lower priority.';
COMMENT ON COLUMN conversation.priority_level IS 'Human-readable priority level based on the priority integer.';
COMMENT ON COLUMN conversation.is_replied IS 'Flag indicating whether a reply has been sent in the conversation.';
COMMENT ON COLUMN conversation.recipient_to IS 'Array of primary recipient email addresses involved in the conversation.';
COMMENT ON COLUMN conversation.recipient_cc IS 'Array of CC (carbon copy) recipient email addresses involved in the conversation.';
COMMENT ON COLUMN conversation.participants IS 'Array of all participant email addresses in the conversation.';
COMMENT ON COLUMN conversation.tags IS 'Array of tags or keywords associated with the conversation for enhanced search and filtering.';
COMMENT ON COLUMN conversation.status IS 'Current status of the conversation (e.g., Active, Archived, Closed).';
COMMENT ON COLUMN conversation.last_activity_at IS 'Timestamp of the last activity in the conversation.';
COMMENT ON COLUMN conversation.created_at IS 'Timestamp when the conversation was created.';
COMMENT ON COLUMN conversation.updated_at IS 'Timestamp when the conversation was last updated.';

-- 3. Create Indexes for Enhanced Query Performance
CREATE INDEX idx_conversation_conversation_id ON conversation (conversation_id);
CREATE INDEX idx_conversation_last_message_id ON conversation (last_message_id);
CREATE INDEX idx_conversation_recipient_to ON conversation USING GIN (recipient_to);
CREATE INDEX idx_conversation_recipient_cc ON conversation USING GIN (recipient_cc);
CREATE INDEX idx_conversation_participants ON conversation USING GIN (participants);
CREATE INDEX idx_conversation_tags ON conversation USING GIN (tags);
CREATE INDEX idx_conversation_category ON conversation (category);
CREATE INDEX idx_conversation_priority ON conversation (priority);
CREATE INDEX idx_conversation_status ON conversation (status);
CREATE INDEX idx_conversation_last_activity_at ON conversation (last_activity_at);

-- 4. Create a Trigger to Automatically Update 'updated_at' Timestamp
CREATE OR REPLACE FUNCTION update_conversation_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_conversation_updated_at
BEFORE UPDATE ON conversation
FOR EACH ROW
EXECUTE FUNCTION update_conversation_updated_at();
