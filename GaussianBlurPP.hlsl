Texture2D tx : register(t0);
SamplerState samLinear : register(s0);

static float2 offset = float2(1 / 1920.0f , 1 / 1080.0f);

struct PS_INPUT
{
    float4 Pos : SV_POSITION;
    float2 Tex : TEXCOORD;
};


float4 PS(PS_INPUT input) : SV_Target
{
    float4 clr = float4(0.0f,0.0f,0.0f,0.0f);

    int size = 5;
    int halfSize = size * 0.5f;

    int multipliers[][5] =
    {
        { 2, 4, 5, 4, 2 },
        { 4, 9, 12, 9, 4 },
        { 5, 12, 15, 12, 5 },
        { 4, 9, 12, 9, 4 },
        { 2, 4, 5, 4, 2 },
    };

    for (int x = -halfSize; x <= halfSize; ++x)
    {
        for (int y = -halfSize; y <= halfSize; ++y)
        {
            float4 tmp = tx.Sample(samLinear, input.Tex + float2(x, y) * offset);

            clr += multipliers[halfSize + x][halfSize + y] * tmp;
        }
    }

    clr /= 159.0f;
    clr.a = 1.0f;
    return clr;
}
