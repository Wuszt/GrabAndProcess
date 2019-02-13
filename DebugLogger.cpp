#include "DebugLogger.h"

std::string DebugLogger::s_currentMessage;
bool DebugLogger::s_forceFlush;

void DebugLogger::OnFrameBegin()
{
    s_forceFlush = false;
    s_currentMessage.clear();
}

void DebugLogger::Log(std::string output)
{
    s_currentMessage.append(output + "\n");
}

void DebugLogger::OnFrameEnd()
{
    if (s_forceFlush)
    {
        std::system("cls");
        std::cout << s_currentMessage;
    }
}

void DebugLogger::ForceFlush()
{
    s_forceFlush = true;
}
