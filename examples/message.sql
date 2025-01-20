INSERT INTO message (
    conversation_id,
    message_id,
    thread_id,
    sender,
    reply_to,
    recipient_to,
    recipient_cc,
    subject,
    message_body,
    summary,
    category,
    priority,
    email_type,
    is_read,
    is_replied,
    is_draft,
    recipient_role,
    attachments,
    labels,
    metadata,
    source
) VALUES (
    '550e8400-e29b-41d4-a716-446655440000', -- conversation_id
    'msg-12345',                              -- message_id
    '550e8400-e29b-41d4-a716-446655440001', -- thread_id
    'sender@example.com',                     -- sender
    'replyto@example.com',                    -- reply_to
    ARRAY['recipient1@example.com', 'recipient2@example.com'], -- recipient_to
    ARRAY['cc1@example.com'],                -- recipient_cc
    'Meeting Agenda',                        -- subject
    'Please find the meeting agenda attached.', -- message_body
    'Agenda for upcoming meeting',            -- summary
    'Work',                                  -- category
    2,                                       -- priority
    'inbound',                               -- email_type
    FALSE,                                   -- is_read
    FALSE,                                   -- is_replied
    FALSE,                                   -- is_draft
    TRUE,                                    -- recipient_role
    '[{"filename": "agenda.pdf", "url": "http://example.com/agenda.pdf"}]', -- attachments
    ARRAY['work', 'meeting'],                -- labels
    '{"processed": false}',                  -- metadata
    'web'                                    -- source
);


INSERT INTO attachments (
    message_id,
    filename,
    url
) VALUES (
    1, -- Assuming the message with id=1 exists
    'agenda.pdf',
    'http://example.com/agenda.pdf'
);




psql -d your_database -c "\d+ message"
