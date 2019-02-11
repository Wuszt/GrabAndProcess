// THIS CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO
// THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
// PARTICULAR PURPOSE.
//
// Copyright (c) Microsoft Corporation. All rights reserved
//----------------------------------------------------------------------

Texture2D tx : register(t0);
SamplerState samLinear : register(s0);

static float2 offset = float2(1 / 1920.0f , 1 / 1080.0f);

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};

float3 GetMean(float3 arr[9])
{
    float3 val = 0.0f;

    for (int i = 0; i < 9; ++i)
    {
        val += arr[i];
    }

    return val / 9.0f;
}

float3 GetVariation(float3 arr[9], float3 mean)
{
    float3 val = 0.0f;

    for (int i = 0; i < 9; ++i)
    {
        float3 diff = (arr[i] - mean);
        val += diff * diff;
    }

    return val / 9.0f;
}

void GetPixelsArray(float2 mainCoords, out float3 output[25])
{
    for (int x = -2; x <= 2; ++x)
    {
        for (int y = -2; y <= 2; ++y)
        {
            output[(x + 2) + 5 * (y + 2)] = tx.Sample(samLinear, mainCoords + float2(x, y) * offset).rgb;
        }
    }
}

float3 GetMeanWithSmallestVar(float3 means[4], float3 vars[4])
{
    float3 mean = means[0];
    float3 var = vars[0];

    for (int i = 1; i < 4; ++i)
    {
        for (int j = 0; j < 3; ++j)
        {
            if (vars[i][j] < var[j])
            {
                mean[j] = means[i][j];
                var[j] = vars[i][j];
            }
        }
    }

    return mean;
}

float3 Kuwahara(PS_INPUT input)
{
    float3 pixels[25];
    GetPixelsArray(input.Tex, pixels);

    float3 nw[] = { pixels[0], pixels[5], pixels[10], pixels[1], pixels[2], pixels[6], pixels[7], pixels[11], pixels[12] };
    float3 ne[] = { pixels[10], pixels[15], pixels[20], pixels[11], pixels[16], pixels[21], pixels[12], pixels[17], pixels[22] };

    float3 sw[] = { pixels[2], pixels[7], pixels[12], pixels[3], pixels[8], pixels[13], pixels[4], pixels[9], pixels[14] };
    float3 se[] = { pixels[12], pixels[17], pixels[22], pixels[13], pixels[18], pixels[23], pixels[14], pixels[14], pixels[19] };

    float3 nwMean = GetMean(nw);
    float3 nwVar = GetVariation(nw, nwMean);

    float3 neMean = GetMean(ne);
    float3 neVar = GetVariation(ne, neMean);

    float3 swMean = GetMean(sw);
    float3 swVar = GetVariation(sw, swMean);

    float3 seMean = GetMean(se);
    float3 seVar = GetVariation(se, seMean);

    float3 means[] = { nwMean, neMean, swMean, seMean };
    float3 vars[] = { nwVar, neVar, swVar, seVar };

    return GetMeanWithSmallestVar(means, vars);
}

//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS(PS_INPUT input) : SV_Target
{
    float3 clr = tx.Sample(samLinear, input.Tex).rgb;
    return float4(Kuwahara(input), 1.0f);
}