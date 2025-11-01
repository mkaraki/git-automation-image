#!/usr/bin/env pwsh

Import-Module Sentry

Start-Sentry {
    $_.Dsn = $env:SENTRY_DSN
    $_.SendDefaultPii = $false
}

trap {
    $_ | Out-Sentry
}

$transaction = Start-SentryTransaction 'task-test.ps1' 'test.ps1'

$span = $transaction.StartChild("file.mkdir")
New-Item -Force -ItemType Directory /tmp/image-test
$span.Finish()

Set-Location /tmp/image-test

$span = $transaction.StartChild("git.init")
git init
$span.Finish()

$transaction.Finish()