.class public Landroid/fix/TextView;
.super Landroid/widget/TextView;
.source "src"


# instance fields
.field private mAnimating:Z

.field private mGradientMatrix:Landroid/graphics/Matrix;

.field private mLinearGradient:Landroid/graphics/LinearGradient;

.field private mPaint:Landroid/graphics/Paint;

.field private mTranslate:I

.field private mViewWidth:I


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 3

    .prologue
    .line 18
    invoke-direct {p0, p1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 12
    const/4 v0, 0x0

    iput v0, p0, Landroid/fix/TextView;->mViewWidth:I

    .line 13
    const/4 v0, 0x0

    iput v0, p0, Landroid/fix/TextView;->mTranslate:I

    .line 14
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/fix/TextView;->mAnimating:Z

    .line 19
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;)V
    .registers 4

    .prologue
    .line 22
    invoke-direct {p0, p1, p2}, Landroid/widget/TextView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;)V

    .line 12
    const/4 v0, 0x0

    iput v0, p0, Landroid/fix/TextView;->mViewWidth:I

    .line 13
    const/4 v0, 0x0

    iput v0, p0, Landroid/fix/TextView;->mTranslate:I

    .line 14
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/fix/TextView;->mAnimating:Z

    .line 23
    return-void
.end method

.method public constructor <init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V
    .registers 5

    .prologue
    .line 26
    invoke-direct {p0, p1, p2, p3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;Landroid/util/AttributeSet;I)V

    .line 12
    const/4 v0, 0x0

    iput v0, p0, Landroid/fix/TextView;->mViewWidth:I

    .line 13
    const/4 v0, 0x0

    iput v0, p0, Landroid/fix/TextView;->mTranslate:I

    .line 14
    const/4 v0, 0x1

    iput-boolean v0, p0, Landroid/fix/TextView;->mAnimating:Z

    .line 27
    return-void
.end method


# virtual methods
.method protected onDraw(Landroid/graphics/Canvas;)V
    .registers 6

    .prologue
    .line 44
    invoke-super {p0, p1}, Landroid/widget/TextView;->onDraw(Landroid/graphics/Canvas;)V

    .line 45
    iget-boolean v0, p0, Landroid/fix/TextView;->mAnimating:Z

    if-eqz v0, :cond_36

    iget-object v0, p0, Landroid/fix/TextView;->mGradientMatrix:Landroid/graphics/Matrix;

    if-eqz v0, :cond_36

    .line 46
    iget v0, p0, Landroid/fix/TextView;->mTranslate:I

    iget v1, p0, Landroid/fix/TextView;->mViewWidth:I

    div-int/lit8 v1, v1, 0xa

    add-int/2addr v0, v1

    iput v0, p0, Landroid/fix/TextView;->mTranslate:I

    .line 47
    iget v0, p0, Landroid/fix/TextView;->mTranslate:I

    iget v1, p0, Landroid/fix/TextView;->mViewWidth:I

    mul-int/lit8 v1, v1, 0x2

    if-le v0, v1, :cond_21

    .line 48
    iget v0, p0, Landroid/fix/TextView;->mViewWidth:I

    neg-int v0, v0

    iput v0, p0, Landroid/fix/TextView;->mTranslate:I

    .line 50
    :cond_21
    iget-object v0, p0, Landroid/fix/TextView;->mGradientMatrix:Landroid/graphics/Matrix;

    iget v1, p0, Landroid/fix/TextView;->mTranslate:I

    int-to-float v1, v1

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/graphics/Matrix;->setTranslate(FF)V

    .line 51
    iget-object v0, p0, Landroid/fix/TextView;->mLinearGradient:Landroid/graphics/LinearGradient;

    iget-object v1, p0, Landroid/fix/TextView;->mGradientMatrix:Landroid/graphics/Matrix;

    invoke-virtual {v0, v1}, Landroid/graphics/LinearGradient;->setLocalMatrix(Landroid/graphics/Matrix;)V

    .line 52
    const-wide/16 v0, 0x32

    invoke-virtual {p0, v0, v1}, Landroid/fix/TextView;->postInvalidateDelayed(J)V

    .line 54
    :cond_36
    return-void
.end method

.method protected onSizeChanged(IIII)V
    .registers 13

    .prologue
    const/4 v7, 0x0

    const/4 v6, 0x3

    .line 31
    invoke-super {p0, p1, p2, p3, p4}, Landroid/widget/TextView;->onSizeChanged(IIII)V

    .line 32
    iget v0, p0, Landroid/fix/TextView;->mViewWidth:I

    if-nez v0, :cond_41

    .line 33
    invoke-virtual {p0}, Landroid/fix/TextView;->getMeasuredWidth()I

    move-result v0

    iput v0, p0, Landroid/fix/TextView;->mViewWidth:I

    .line 34
    iget v0, p0, Landroid/fix/TextView;->mViewWidth:I

    if-lez v0, :cond_41

    .line 35
    invoke-virtual {p0}, Landroid/fix/TextView;->getPaint()Landroid/text/TextPaint;

    move-result-object v0

    iput-object v0, p0, Landroid/fix/TextView;->mPaint:Landroid/graphics/Paint;

    .line 36
    new-instance v0, Landroid/graphics/LinearGradient;

    iget v1, p0, Landroid/fix/TextView;->mViewWidth:I

    neg-int v1, v1

    int-to-float v1, v1

    const/4 v2, 0x0

    const/4 v3, 0x0

    const/4 v4, 0x0

    new-array v5, v6, [I

    fill-array-data v5, :array_42

    new-array v6, v6, [F

    fill-array-data v6, :array_4c

    sget-object v7, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    invoke-direct/range {v0 .. v7}, Landroid/graphics/LinearGradient;-><init>(FFFF[I[FLandroid/graphics/Shader$TileMode;)V

    iput-object v0, p0, Landroid/fix/TextView;->mLinearGradient:Landroid/graphics/LinearGradient;

    .line 39
    iget-object v0, p0, Landroid/fix/TextView;->mPaint:Landroid/graphics/Paint;

    iget-object v1, p0, Landroid/fix/TextView;->mLinearGradient:Landroid/graphics/LinearGradient;

    invoke-virtual {v0, v1}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 40
    new-instance v0, Landroid/graphics/Matrix;

    invoke-direct {v0}, Landroid/graphics/Matrix;-><init>()V

    iput-object v0, p0, Landroid/fix/TextView;->mGradientMatrix:Landroid/graphics/Matrix;

    .line 43
    :cond_41
    return-void

    .line 36
    :array_42
    .array-data 4
        -0xff8801
        -0x10000
        -0xff8801
    .end array-data

    :array_4c
    .array-data 4
        0x0
        0x3f000000  # 0.5f
        0x3f800000  # 1.0f
    .end array-data
.end method

.method public setAnimating(Z)V
    .registers 2

    .prologue
    .line 57
    iput-boolean p1, p0, Landroid/fix/TextView;->mAnimating:Z

    .line 58
    invoke-virtual {p0}, Landroid/fix/TextView;->invalidate()V

    .line 59
    return-void
.end method
