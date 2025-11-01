#!/usr/bin/env pwsh

Import-Module Sentry

Start-Sentry {
    $_.SendDefaultPii = $false
}

$transaction = Start-SentryTransaction 'task-test.ps1' 'test.ps1'

$span = $transaction.StartChild("file.mkdir")
New-Item -Force /tmp/image-test
$span.Finish()

Set-Location /tmp/image-test

$span = $transaction.StartChild("git.init")
git init
$span.Finish()

$transaction.Finish()