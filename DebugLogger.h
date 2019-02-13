#pragma once

#include <string>
#include <iostream>
#include <windows.h>

class DebugLogger
{
public:
    static void OnFrameBegin();
    static void Log(std::string output);
    static void OnFrameEnd();
    static void ForceFlush();

private:
    static std::string s_currentMessage;
    static bool s_forceFlush;
};

