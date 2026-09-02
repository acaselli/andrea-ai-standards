# Errors and feedback standard

Write every error for a user who has never seen the app's internals and does not care about them. The message states what happened and what to do next; the technical detail goes to the log.

## Contents

- [The test every message must pass](#the-test-every-message-must-pass)
- [Write the message](#write-the-message)
- [Match the message to the error class](#match-the-message-to-the-error-class)
- [Choose where the message appears](#choose-where-the-message-appears)
- [Toast durations](#toast-durations)
- [Never reveal](#never-reveal)
- [Examples](#examples)
- [Implementation checklist](#implementation-checklist)

## The test every message must pass

Read the message as someone seeing it for the first time and ask: is it clear what happened, and is it clear what I do next? If either answer is no, rewrite it. Sometimes the only next step is to ask the IT administrator, and that is an acceptable answer as long as the message says so.

## Write the message

- Lead with the outcome in the user's own terms, then the next step. Add the cause only when it helps the user act.
- Be specific, not long. The goal is the shortest message that makes the next step obvious. Long messages are not read.
- Always state whether the action happened. After a failed save, payment, or send, the user's first question is "did it go through?". If the outcome is unknown, say so and tell them how to check.
- Keep the user's input. An error never clears a form or discards a draft.
- Do not give the app a voice. Write "The payment could not be deleted", not "I could not delete the payment" or "We're sorry".
- Stay calm and neutral: no "Oops", no exclamation marks, no humour, no blame such as "you entered an invalid value".
- Point to the project's configured support channel when the user needs help (a named team, an email, a ticket form). If the project has not defined one, ask for it rather than inventing one.
- Prevent before you explain. If the user cannot perform an action, hide the control or disable it with a short tooltip instead of letting them trigger a permission error.
- Error messages are UI strings: translate them like everything else and author them in the UI layer. Never pass a backend error string through to the screen.

## Match the message to the error class

| Class | What the user needs | Placement |
| --- | --- | --- |
| Validation or business rule (the user can fix it) | Exactly what to change, and where | Inline, next to the field or the blocked action |
| Permission | What cannot be done and where to ask, without the rule behind it | Inline or dialog; better still, prevent it |
| Conflict (someone else changed the record) | What happened and an action to reload or compare | Dialog or inline banner that persists |
| Transient or system (network, server, timeout) | That the action did not complete, whether anything was saved, to try again, and where to get help if it persists | Persistent if it blocked the task, toast if it did not |
| Not found or no access to a record | A neutral "not available" message and a way back, without confirming that the record exists | Full-page or panel state |

## Choose where the message appears

- Anything that blocks the task stays visible until the user acts on it: inline, in a banner, or in a dialog.
- Toasts are only for non-blocking or transient feedback: a mutation that succeeded, a background refresh that failed while stale data is still shown, a retry that will happen automatically.
- Use Sonner at `bottom-right` unless the project already has a deliberate notification pattern. For longer asynchronous work, use one promise toast that moves from loading to success or error rather than emitting separate toasts.
- Never stack a toast on top of an inline error for the same event. One event, one message.

## Toast durations

Nothing the user needs to act on may disappear on its own.

- Error toasts stay until the user dismisses them. Always show the close button, so keyboard users are not left with swipe as the only way out.
- Warning toasts that ask for a decision or an action stay like errors. Purely informational warnings time out like info.
- Success and info toasts time out. Use Sonner's default of four seconds for one-line messages and six to eight seconds for two lines. Never put information the user must retain, such as a generated code, in a timed toast.
- A promise toast stays in its loading state until the work resolves, then follows the rule for its outcome: success times out, error stays.
- Give repeated failures a stable toast id so the message updates in place instead of stacking, and keep the visible limit at three.

## Never reveal

- HTTP status codes, stack traces, SQL, exception names, table or column names, internal identifiers, or internal URLs.
- Role names, who else can perform the action, or the rule that produced the denial. "Your role does not allow deleting payments" is fine; "only Finance Managers can delete payments" is not.
- Whether an account, email, or record exists to someone not entitled to know. Login failures say "The email or password is incorrect", never which one.
- Other users' data.

The technical detail belongs in the log instead: status code, request identifier, acting user identifier, stack trace, and the request payload with secrets and personal data stripped. Other users' data is never written to the log to explain an error; log identifiers, not records.

## Examples

Bad: `Oops! Error 403. Please contact your administrator.`
Good: `Your role does not allow deleting payments. If you think you should be able to, contact the IT administrator.`

Bad: `Constraint violation: payments_supplier_fk on table payments.`
Good: `This supplier cannot be deleted while it still has payments. Remove or reassign its payments in the Payments section, then try again.`

Bad: `Request failed with status 502.`
Good: `The payment could not be saved and no changes were made. Check your connection and try again. If the problem continues, contact the IT administrator.`

Bad: `Invalid input.`
Good, inline under the field: `Enter an end date after the start date.`

Bad: `Only Finance Managers can approve invoices above €10.000.`
Good: `This invoice needs approval from another user. It has been saved and marked as awaiting approval.`

## Implementation checklist

- Every user-facing error passes the first-time-reader test: what happened, what next.
- The message says whether the action was applied, partially applied, or not applied.
- User input and drafts survive the error.
- Placement follows the error class: blocking errors persist, only non-blocking feedback goes in a toast.
- Error toasts and action-required warnings persist until dismissed and show a close button; success and info toasts time out.
- Messages are translated and authored in the UI layer, never passed through from the API.
- No status codes, internals, role names, or existence hints reach the screen; all of it reaches the log.
- Controls the user cannot use are hidden or disabled, so permission errors are rare.
