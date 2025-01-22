CREATE TABLE postgres.public.message (
  id text NOT NULL,
  created_date_time timestamp NULL,
  last_modified_date_time timestamp NULL,
  categories _text NULL,
  received_date_time timestamp NULL,
  sent_date_time timestamp NULL,
  has_attachments bool NULL,
  internet_message_id text NULL,
  subject text NULL,
  body_preview text NULL,
  importance text NULL,
  conversation_id text NULL,
  is_read bool NULL,
  web_link text NULL,
  inference_classification text NULL,
  body_content_type text NULL,
  body_content text NULL,
  sender_name text NULL,
  sender_email text NULL,
  from_name text NULL,
  from_email text NULL,
  to_recipients _jsonb NULL,
  cc_recipients _jsonb NULL,
  bcc_recipients _jsonb NULL,
  reply_to _jsonb NULL,
  summary text NULL,
  tags _text NULL,
  draft text NULL,
  CONSTRAINT message_pkey PRIMARY KEY (id)
);

CREATE TABLE postgres.public.configuration (
    id SERIAL PRIMARY KEY, -- Unique identifier for each configuration
    config_key TEXT NOT NULL, -- Key for the configuration (e.g., 'theme', 'notifications')
    config_value TEXT NOT NULL, -- Value of the configuration (e.g., 'dark', 'enabled')
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Timestamp when the configuration was created
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Timestamp when the configuration was last updated
);

-- Create a trigger function to update the `updated_at` column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = CURRENT_TIMESTAMP;
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger for the table to automatically update `updated_at`
CREATE TRIGGER set_updated_at
BEFORE UPDATE ON configuration
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();



INSERT INTO configuration (id, config_key, config_value)
VALUES 
(1, 'category-tag-config', 
'My Name is Vishal Pandey\n\nI work in Lumiq as Team Lead\n\nGiven the summary of the conversation till now, the API response of the Outlook email, please categorize the email in the following category:\n\n1. important - Any message which is addressed to me specifically and is work-related.\n2. not_important - All other messages which are not relevant for me and my role.\n3. fyi - Email in which I am in the CC list and the information of the email is to just inform me.\n4. escalation - Email from a client or someone which is expecting resolution on an urgent basis and raising some critical issue about the product or the team.\n\nPlease stick to the defined categories only.\nAlong with that, please generate some tags that are relevant for this scenario. Here, you can use your intelligence and provide relevant tags.');