# Function to display a random welcome message based on terminal width
function Show-RandomWelcomeMessage {
    [CmdletBinding()]
    param (
        [string]$MsgPath = (Join-Path (Split-Path $PROFILE -Parent) "msg\\msg_shell_welcome"),
        [int]$MaxRetryNum = 10,
        [string]$DefaultMsg = "HI. Enjoy Your Day. :P"
    )

    # Validate arguments
    if (-not (Test-Path $MsgPath -PathType Leaf)) {
        Write-Error "Error: Invalid message file path: $MsgPath"
        return
    }

    # Read the entire message file content for metadata parsing
    $fileContentForMetadata = Get-Content -Path $MsgPath -Raw

    # Identify the start and end of a message
    $startMark = "---start---"
    $endMark = "---end---"

    # Read the number of messages from the file
    $numMsgMatch = [regex]::Match($fileContentForMetadata, "msg nums: (\d+)")
    if (-not $numMsgMatch.Success) {
        Write-Error "Error: Could not find 'msg nums:' in $MsgPath"
        Write-Output $DefaultMsg
        return
    }

    # Get all message blocks
    $msgBlocksMeta = @()
    $pattern = "(?sm)$([regex]::Escape($startMark))(.*?)$([regex]::Escape($endMark))"
    [regex]::Matches($fileContentForMetadata, $pattern) | ForEach-Object {
        $blockContent = $_.Groups[1].Value.Trim()
        $msgIndexMatch = [regex]::Match($blockContent, "msg index: (\d+)")
        # Font name is not strictly needed for logic but good for completeness if ever needed
        # $fontNameMatch = [regex]::Match($blockContent, "font name: (.*)")
        $lineRangeMatch = [regex]::Match($blockContent, "line range: (\d+),(\d+)")
        $maxLineWidthMatch = [regex]::Match($blockContent, "max line width: (\d+)")

        if ($msgIndexMatch.Success -and $lineRangeMatch.Success -and $maxLineWidthMatch.Success) {
            $msgBlocksMeta += [PSCustomObject]@{
                Index        = [int]$msgIndexMatch.Groups[1].Value
                StartLine    = [int]$lineRangeMatch.Groups[1].Value
                EndLine      = [int]$lineRangeMatch.Groups[2].Value
                MaxLineWidth = [int]$maxLineWidthMatch.Groups[1].Value
            }
        }
    }

    if ($msgBlocksMeta.Count -eq 0) {
        Write-Warning "Warning: No message blocks could be parsed from $MsgPath."
        Write-Output $DefaultMsg
        return
    }

    Write-Verbose "Successfully parsed $($msgBlocksMeta.Count) message blocks from $MsgPath."

    # Read file lines for actual content extraction later
    $fileLines = Get-Content -Path $MsgPath

    $retryNum = 0
    $terminalWidth = $Host.UI.RawUI.WindowSize.Width
    $availableMessages = $msgBlocksMeta # Initially all messages are available

    while ($retryNum -lt $MaxRetryNum -and $availableMessages.Count -gt 0) {
        $randomIndex = Get-Random -Maximum $availableMessages.Count
        $selectedMsgMeta = $availableMessages[$randomIndex]

        if ($terminalWidth -ge $selectedMsgMeta.MaxLineWidth) {
            # Extract the ASCII art content based on the line range
            # Line numbers in the file are 1-based, array is 0-based
            $startFileIdx = $selectedMsgMeta.StartLine - 1
            $endFileIdx = $selectedMsgMeta.EndLine - 1

            if ($startFileIdx -ge 0 -and $endFileIdx -lt $fileLines.Count -and $startFileIdx -le $endFileIdx) {
                $asciiArt = $fileLines[$startFileIdx..$endFileIdx] -join [System.Environment]::NewLine
                Write-Output $asciiArt
                return # Success
            }
            else {
                Write-Warning "Warning: Invalid line range for message index $($selectedMsgMeta.Index). StartLine: $($selectedMsgMeta.StartLine), EndLine: $($selectedMsgMeta.EndLine). Max lines in file: $($fileLines.Count)."
                # Remove this problematic message from consideration
                $availableMessages = $availableMessages | Where-Object { $_.Index -ne $selectedMsgMeta.Index }
            }
        }
        else {
            # Message too wide, remove it from consideration for next retries
            $availableMessages = $availableMessages | Where-Object { $_.Index -ne $selectedMsgMeta.Index }
        }

        $retryNum++
    }

    # If loop finishes without returning, it means no suitable message was found or retries exhausted
    Write-Output $DefaultMsg
}

Export-ModuleMember -Function Show-RandomWelcomeMessage
