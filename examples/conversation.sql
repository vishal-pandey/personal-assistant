INSERT INTO conversation (
    conversation_id,
    last_message_id,
    subject,
    category,
    priority,
    priority_level,
    is_replied,
    recipient_to,
    recipient_cc,
    participants,
    tags,
    status
) VALUES (
    '550e8400-e29b-41d4-a716-446655440000', -- conversation_id
    1,                                       -- last_message_id (assuming message with id=1 exists)
    'Project Update',                        -- subject
    'Work',                                  -- category
    2,                                       -- priority
    'High',                                  -- priority_level
    FALSE,                                   -- is_replied
    ARRAY['recipient1@example.com', 'recipient2@example.com'], -- recipient_to
    ARRAY['cc1@example.com'],                -- recipient_cc
    ARRAY['sender@example.com', 'recipient1@example.com', 'recipient2@example.com', 'cc1@example.com'], -- participants
    ARRAY['urgent', 'finance'],              -- tags
    'Active'                                 -- status
);
