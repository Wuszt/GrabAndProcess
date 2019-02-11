// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved
//----------------------------------------------------------------------

Texture2D tx : register(t0);
SamplerState samLinear : register(s0);

static const float2 offset = float2(1 / 1920.0f , 1 / 1080.0f);
static const float PI = 3.14159265f;

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};

float2 ExtractXandY(float4 input)
{
    return input.xy * 2.0f - 1.0f;
}

float3 GetDataForPixelWithOffset(float2 mainCoords, float2 off)
{
    float4 samp = tx.Sample(samLinear, mainCoords + off * offset);
    return float3(ExtractXandY(samp), samp.z);
}

float NonMaximumSuppression(PS_INPUT input)
{
    float3 data = GetDataForPixelWithOffset(input.Tex, float2(0, 0));

    float mg = data.z;

    float angle = atan2(data.y, data.x) * 180 / PI;

    return float4(mg, mg, mg, 1.0f);

    //if ((angle >= -22.5f && 22.5f >= angle) || -157.5f >= angle || angle >= 157.5)
    //{
    //    if (GetDataForPixelWithOffset(input.Tex, float2(-1, 0)).z > data.z || GetDataForPixelWithOffset(input.Tex, float2(1, 0)).z > data.z)
    //        mg = 0;
    //}
    //else if ((angle >= 22.5f && 67.5f >= angle) || (angle >= -157.5f && -112.5f >= angle))
    //{
    //    if (GetDataForPixelWithOffset(input.Tex, float2(-1, -1)).z > data.z || GetDataForPixelWithOffset(input.Tex, float2(1, 1)).z > data.z)
    //        mg = 0;
    //}
    //else if ((angle >= 67.5f && 112.5f >= angle) || (angle >= -112.5f && -67.5f >= angle))
    //{
    //    if (GetDataForPixelWithOffset(input.Tex, float2(0, -1)).z > data.z || GetDataForPixelWithOffset(input.Tex, float2(0, 1)).z > data.z)
    //        mg = 0;
    //}
    //else
    //{
    //    if (GetDataForPixelWithOffset(input.Tex, float2(1, -1)).z > data.z || GetDataForPixelWithOffset(input.Tex, float2(-1, 1)).z > data.z)
    //        mg = 0;
    //}

    if ((angle >= 0.0f && 45.0f >= angle) || (angle >= -180.0f && -135.0f >= angle))
    {
        float top0 = GetDataForPixelWithOffset(input.Tex, float2(1, 0)).z;
        float top1 = GetDataForPixelWithOffset(input.Tex, float2(1, 1)).z;

        float bot0 = GetDataForPixelWithOffset(input.Tex, float2(-1, 0)).z;
        float bot1 = GetDataForPixelWithOffset(input.Tex, float2(-1, -1)).z;

        float x = abs(data.y / data.z);

        float interpTop = (top1 - top0) * x + top0;
        float interpBot = (bot1 - bot0) * x + bot0;

        if (interpTop > mg || interpBot > mg)
            mg = 0.0f;
    }
    else if ((angle >= 45.0f && 90.0f >= angle) || (angle >= -135.0f && -90.0f >= angle))
    {
        float top0 = GetDataForPixelWithOffset(input.Tex, float2(0, 1)).z;
        float top1 = GetDataForPixelWithOffset(input.Tex, float2(1, 1)).z;

        float bot0 = GetDataForPixelWithOffset(input.Tex, float2(0, -1)).z;
        float bot1 = GetDataForPixelWithOffset(input.Tex, float2(-1, -1)).z;

        float x = abs(data.x / data.z);

        float interpTop = (top1 - top0) * x + top0;
        float interpBot = (bot1 - bot0) * x + bot0;

        if (interpTop > mg || interpBot > mg)
            mg = 0.0f;
    }
    else if ((angle >= 90.0f && 135.0f >= angle) || (angle >= -90.0f && -45.0f >= angle))
    {
        float top0 = GetDataForPixelWithOffset(input.Tex, float2(0, 1)).z;
        float top1 = GetDataForPixelWithOffset(input.Tex, float2(-1, 1)).z;

        float bot0 = GetDataForPixelWithOffset(input.Tex, float2(0, -1)).z;
        float bot1 = GetDataForPixelWithOffset(input.Tex, float2(1, -1)).z;

        float x = abs(data.x / data.z);

        float interpTop = (top1 - top0) * x + top0;
        float interpBot = (bot1 - bot0) * x + bot0;

        if (interpTop > mg || interpBot > mg)
            mg = 0.0f;
    }
    else if ((angle >= 135.0f && 180.0f >= angle) || (angle >= -45.0f && 0.0f >= angle))
    {
        float top0 = GetDataForPixelWithOffset(input.Tex, float2(-1, 0)).z;
        float top1 = GetDataForPixelWithOffset(input.Tex, float2(-1, 1)).z;

        float bot0 = GetDataForPixelWithOffset(input.Tex, float2(1, 0)).z;
        float bot1 = GetDataForPixelWithOffset(input.Tex, float2(1, -1)).z;

        float x = abs(data.y / data.z);

        float interpTop = (top1 - top0) * x + top0;
        float interpBot = (bot1 - bot0) * x + bot0;

        if (interpTop > mg || interpBot > mg)
            mg = 0.0f;
    }


    return mg;
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
    float e = NonMaximumSuppression(input);

    if (e > 0.45f)
        e = 1.0f;
    else if(e < 0.3f)
        e = 0.0f;

return float4(e, e, e, 1.0f);
}