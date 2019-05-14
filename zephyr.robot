*** Settings ***
Suite Setup                   Setup
Suite Teardown                Teardown
Test Setup                    Reset Emulation
Resource                      /opt/renode/tests/renode-keywords.robot

*** Variables ***
${UART}                       sysbus.uart

*** Keywords ***
Create Machine
    [Arguments]               ${elf}      ${name}     ${id}

    Execute Command           set id ${id}
    Execute Command           $name="${name}"
    Execute Command           $bin=@${CURDIR}/${elf}
    Execute Command           i @scripts/single-node/miv.resc
    Execute Command           showAnalyzer uart Antmicro.Renode.Analyzers.LoggingUartAnalyzer
    ${tester}=                Create Terminal Tester    ${UART}    machine=${name}

    [return]                    ${tester}

*** Test Cases ***
Should Run Philosophers App
    [Tags]                    m2gl025  uart
    Execute Command           logFile @${CURDIR}/artifacts/philosophers.log
    Create Machine            artifacts/zephyr.elf    m2gl025_miv    1
    Start Emulation
    Wait For Line On Uart     EATING     5

Every Philosopher Should Eat
    [Tags]                    m2gl025  uart  threading
    Execute Command           logFile @${CURDIR}/artifacts/philosophers_eating.log
    Create Machine            artifacts/zephyr.elf    m2gl025_miv    2
    Start Emulation
    Wait For Line On Uart     Philosopher 0 .* EATING     5    treatAsRegex=True
    Wait For Line On Uart     Philosopher 1 .* EATING     5    treatAsRegex=True
    Wait For Line On Uart     Philosopher 2 .* EATING     5    treatAsRegex=True
    Wait For Line On Uart     Philosopher 3 .* EATING     5    treatAsRegex=True
    Wait For Line On Uart     Philosopher 4 .* EATING     5    treatAsRegex=True

