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
    Execute Command           logFile @${CURDIR}/artifacts/log-${id}
    Execute Command           $name="${name}"
    Execute Command           $bin=@${CURDIR}/${elf}
    Execute Command           i @scripts/single-node/miv.resc
    Execute Command           showAnalyzer uart Antmicro.Renode.Analyzers.LoggingUartAnalyzer
    ${tester}=                Create Terminal Tester    ${UART}    machine=${name}

    [return]                    ${tester}

*** Test Cases ***
Should Run Philosophers App
    [Tags]                    m2gl025  uart
    Create Machine            artifacts/zephyr.elf    m2gl025_miv    1
    Start Emulation
    Wait For Line On Uart     EATING     5

Every Philosopher Should Eat
    [Tags]                    m2gl025  uart  threading
    Create Machine            artifacts/zephyr.elf    m2gl025_miv    2
    Start Emulation
    Wait For Line On Uart     Philosopher 0 .* EATING     5    treatAsRegex=True

