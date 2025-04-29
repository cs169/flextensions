# spec/services/email_service_spec.rb
require 'rails_helper'

RSpec.describe EmailService, type: :service do
  describe '.render_templates' do
    let(:subject_tmpl) { 'Hello, {{first_name}} {{last_name}}' }
    let(:body_tmpl) do
      <<~BODY
        Dear {{first_name}},

        Your order {{order_id}} has shipped.

        Thanks,
        {{company}}
      BODY
    end

    let(:mapping) do
      {
        'first_name' => 'Alice',
        'last_name' => 'Smith',
        'order_id' => '12345',
        'company' => 'Acme Co'
      }
    end

    it 'replaces all {{placeholders}} in subject and body' do
      result = described_class.render_templates(subject_tmpl, body_tmpl, mapping)
      expect(result[:subject]).to eq('Hello, Alice Smith')

      expect(result[:body]).to include('Dear Alice,')
      expect(result[:body]).to include('Your order 12345 has shipped.')
      expect(result[:body]).to include("Thanks,\nAcme Co")
    end

    it 'leaves unknown placeholders untouched' do
      partial = described_class.render_templates(
        'Hi {{foo}}', 'Bar {{baz}}', { 'foo' => 'X' }
      )
      expect(partial[:subject]).to eq('Hi X')
      expect(partial[:body]).to eq('Bar {{baz}}')
    end
  end

  describe '.send_email' do
    let(:to)        { 'bob@example.com' }
    let(:from)      { 'noreply@acme.com' }
    let(:sub_tmpl)  { 'Order {{order_id}} ready' }
    let(:body_tmpl) { "Hi {{name}}\nYour order is ready." }
    let(:mapping)   { { 'order_id' => '42', 'name' => 'Bob' } }

    before do
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.deliveries.clear
    end

    context 'when deliver_later: false (default)' do
      it 'sends a mail immediately with HTML line breaks' do
        described_class.send_email(
          to: to,
          from: from,
          subject_template: sub_tmpl,
          body_template: body_tmpl,
          mapping: mapping,
          deliver_later: false
        )

        mail = ActionMailer::Base.deliveries.last
        expect(mail).to be_present
        expect(mail.to).to    eq([to])
        expect(mail.from).to  eq([from])
        expect(mail.subject).to eq('Order 42 ready')
        # Our service inserts `<br>\n` for newlines in HTML mode
        expect(mail.body.encoded).to include('Hi Bob<br>')
        expect(mail.body.encoded).to include('Your order is ready.')
      end
    end

    context 'when deliver_later: true' do
      include ActiveJob::TestHelper

      before do
        ActiveJob::Base.queue_adapter = :test
        clear_enqueued_jobs
      end

      it 'enqueues an ActionMailer delivery job' do
        expect do
          described_class.send_email(
            to: to,
            from: from,
            subject_template: sub_tmpl,
            body_template: body_tmpl,
            mapping: mapping,
            deliver_later: true
          )
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
      end
    end
  end
end
