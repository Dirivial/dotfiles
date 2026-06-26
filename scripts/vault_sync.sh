#!/usr/bin/env bash

# Define a function to send dunstify notifications
send_notification() {
  local type=$1 # "success" or "error"
  local message=$2
  local title="Git Automation"

  if command -v dunstify &>/dev/null; then
    if [ "$type" == "success" ]; then
      dunstify -u low -t 3000 "$title" "$message"
    elif [ "$type" == "error" ]; then
      dunstify -u critical -t 5000 "$title" "$message"
    fi
  else
    echo "dunstify command not found. Please install it for notifications."
    echo "$title: $message"
  fi
}

cd ~/personal/obsidian-vault/ || {
  send_notification "error" "Failed to change directory to Git repository."
  exit 1
}

# --- 1. Git Pull ---
echo "Attempting git pull..."
git pull
if [ $? -ne 0 ]; then
  send_notification "error" "Git pull failed. Please check your connection or repository status."
  exit 1
fi
echo "Git pull successful."

# --- 2. Git Add All ---
echo "Attempting git add all files..."
git add .
if [ $? -ne 0 ]; then
  send_notification "error" "Git add failed. Could not stage files."
  exit 1
fi
echo "Git add successful."

# --- 3. Get Current Date and Time for Commit Message ---
COMMIT_MESSAGE=$(date +"%Y-%m-%d %H:%M:%S")
echo "Commit message will be: $COMMIT_MESSAGE"

# --- 4. Git Commit ---
echo "Attempting git commit..."
git commit -m "$COMMIT_MESSAGE"
if [ $? -ne 0 ]; then
  # Check if the failure is due to "nothing to commit"
  if git status --porcelain | grep -q .; then
    # There are staged changes but commit still failed (e.g., pre-commit hook)
    send_notification "error" "Git commit failed. There might be an issue with the commit operation itself."
  else
    # No changes to commit, which is not an error for this script's purpose
    # I don't want to spam the user with notifications for every commit
    # send_notification "success" "No changes to commit. Skipping push."
    exit 0 # Exit successfully as there's nothing to push
  fi
  exit 1
fi
echo "Git commit successful."

# --- 5. Git Push ---
echo "Attempting git push..."
git push
if [ $? -ne 0 ]; then
  send_notification "error" "Git push failed. Please check your remote repository or credentials."
  exit 1
fi
echo "Git push successful."

# --- Success Notification ---
send_notification "success" "Git operations completed successfully!"

exit 0
