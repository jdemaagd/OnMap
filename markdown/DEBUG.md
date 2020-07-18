# Xcode Debugging

## Lingo

- Logic error: 
    - a bug in a program that causes it to operate incorrectly
    - but not to terminate abnormally (or crash)
- Runtime errors: 
    - issues that occur while your application is running
    - these can be logic errors or errors that cause your application to crash
- software bug: 
    - an error, flaw, failure, or fault in a computer program or system 
    - causes it to produce an incorrect or unexpected result, or to behave in unintended ways
- static (or compilation) errors: 
    - issues identified by the compiler that must be fixed prior to running your application
- warning: 
    - issues that might cause problems or have unintended side-effects on your running application

## Process

- Reproduce the Problem
    - If you cannot reproduce the problem,
    - then you probably do not understand it
- Gather Debug information
    - Logs, program state, etc..
    - What is value of variable?
    - What kind of error (i.e. EXC_BAD_ACCESS)
    - What functions/methods led to the error?
- Form Hypothesis
- Try a Fix
    - Maximize the information gained per fix!
- Loop: try to reproduce problem

## Logging

- [Apple Logging](https://developer.apple.com/documentation/os/logging)
- [XCGLogger](https://github.com/DaveWoodCom/XCGLogger)
- [Cleanroom Logger](https://github.com/emaloney/CleanroomLogger)
- [CocoaLumberjack Logger](https://github.com/CocoaLumberjack/CocoaLumberjack)

## Debugging

- [Advanced Swift Debugging in LDDB](https://www.youtube.com/watch?v=TaVqL8QdegY)
- [Debugging in Xcode 11](https://developer.apple.com/videos/play/wwdc2019/412/)
- [Debug Icons](https://developer.apple.com/library/archive/documentation/DeveloperTools/Conceptual/debugging_with_xcode/chapters/debugging_tools.html#//apple_ref/doc/uid/TP40015022-CH8-SW19)

## [Low Level Debugger (LLDB)]

- fr v (frame variable)
- help frame variable
- frame info
- frame select 1
- expr print(bugs)
- expr self.bugs.removeAll(keepCapacity: true)
- po bugs (print object)
- po self
- expr unsafeBitCast(0x7fb08e300360, UIImageView.self)
- expr let $bug1 = unsafeBitCast(0x7fb08e300360, UIImageView.self)
- expr print($bug1)
- expr $bug1.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
- breakpoint set --file BugFactory.swift --line 26
- breakpoint set --selector viewDidLoad
- breakpoint list
- breakpoint disable 2
- thread backtrace all
- expr bugs[0].image = UIImage(named: "settings")
- [LLDB Command Examples](https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/gdb_to_lldb_transition_guide/document/lldb-command-examples.html#//apple_ref/doc/uid/TP40012917-CH3-SW1)

## Debugging Hotkeys

- Show Navigator (cmd + O)
- Show Debug Navigator (cmd + 6)
- Show Breakpoint Navigator (cmd + 7)
- Show Debug Area (cmd + shift + 7)
- Open Documentation (cmd + shift + 0)
- Step Over (F6)
- Step Into (F7)
- Step Out (F8)
- Continue (cmd + ctrl + Y)
- Build (cmd + B)
- Run (cmd + R)
- Activate/Deactivate Breakpoint (cmd + Y)
- Quick Search (cmd + shift + O)

## Debugging Ninja

- [Apple's WWDC Sessions](https://developer.apple.com/videos/)
- [HopperApp](https://www.hopperapp.com/)
- [RevealApp](https://revealapp.com/)
- [Apple's Performance Tools](https://developer.apple.com/library/archive/documentation/Performance/Conceptual/PerformanceOverview/PerformanceTools/PerformanceTools.html)

## Resources

- [Basic Animations](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/CreatingBasicAnimations/CreatingBasicAnimations.html)
- [Prototyping Animations](http://mathewsanders.com/prototyping-iOS-iPhone-iPad-animations-in-swift/)
- [Printable/CustomStringConvertible Protocol](https://swiftdoc.org/v3.0/protocol/customstringconvertible/)
- [DebugPrintable/CustomDebugStringConvertible Protocol](https://swiftdoc.org/v3.0/protocol/customdebugstringconvertible/)
- [dump](https://stackoverflow.com/questions/38773979/is-there-a-way-to-pretty-print-swift-dictionaries-to-the-console)
- [Report Apple Bug](https://developer.apple.com/bug-reporting/)
- [LLDB](https://lldb.llvm.org/)
- [Intermediate Debugging with Xcode 4.5](https://www.raywenderlich.com/2777-intermediate-debugging-with-xcode-4-5)
- [Xcode OpenGL ES Tools Overview](https://developer.apple.com/library/archive/documentation/3DDrawing/Conceptual/OpenGLES_ProgrammingGuide/ToolsOverview/ToolsOverview.html)
- [Types Supporting Quick Look](https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/CustomClassDisplay_in_QuickLook/CH02-std_objects_support/CH02-std_objects_support.html#//apple_ref/doc/uid/TP40014001-CH3-SW1)
- [unsafeBitCast](https://stackoverflow.com/questions/29441418/lldb-swift-casting-raw-address-into-usable-type)

