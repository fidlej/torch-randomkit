require 'randomkit'
require 'util.warn'
local myTests = {}
local tester = torch.Tester()

local standardGaussianPDFWindow = torch.Tensor({
    {0.058549831524319, 0.070096874908772, 0.080630598589333, 0.089110592667962, 0.094620883979159, 0.096532352630054, 0.094620883979159, 0.089110592667962, 0.080630598589333, 0.070096874908772, 0.058549831524319},
    {0.070096874908772, 0.083921195741359, 0.096532352630054, 0.106684748780159, 0.113281765213783, 0.115570208671698, 0.113281765213783, 0.106684748780159, 0.096532352630054, 0.083921195741359, 0.070096874908772},
    {0.080630598589333, 0.096532352630054, 0.111038635972398, 0.122716671259482, 0.130305046413711, 0.132937382963516, 0.130305046413711, 0.122716671259482, 0.111038635972398, 0.096532352630054, 0.080630598589333},
    {0.089110592667962, 0.106684748780159, 0.122716671259482, 0.135622896239029, 0.144009347774931, 0.146918529576363, 0.144009347774931, 0.135622896239029, 0.122716671259482, 0.106684748780159, 0.089110592667962},
    {0.094620883979159, 0.113281765213783, 0.130305046413711, 0.144009347774931, 0.152914388511582, 0.156003464068888, 0.152914388511582, 0.144009347774931, 0.130305046413711, 0.113281765213783, 0.094620883979159},
    {0.096532352630054, 0.115570208671698, 0.132937382963516, 0.146918529576363, 0.156003464068888, 0.159154943091895, 0.156003464068888, 0.146918529576363, 0.132937382963516, 0.115570208671698, 0.096532352630054},
    {0.094620883979159, 0.113281765213783, 0.130305046413711, 0.144009347774931, 0.152914388511582, 0.156003464068888, 0.152914388511582, 0.144009347774931, 0.130305046413711, 0.113281765213783, 0.094620883979159},
    {0.089110592667962, 0.106684748780159, 0.122716671259482, 0.135622896239029, 0.144009347774931, 0.146918529576363, 0.144009347774931, 0.135622896239029, 0.122716671259482, 0.106684748780159, 0.089110592667962},
    {0.080630598589333, 0.096532352630054, 0.111038635972398, 0.122716671259482, 0.130305046413711, 0.132937382963516, 0.130305046413711, 0.122716671259482, 0.111038635972398, 0.096532352630054, 0.080630598589333},
    {0.070096874908772, 0.083921195741359, 0.096532352630054, 0.106684748780159, 0.113281765213783, 0.115570208671698, 0.113281765213783, 0.106684748780159, 0.096532352630054, 0.083921195741359, 0.070096874908772},
    {0.058549831524319, 0.070096874908772, 0.080630598589333, 0.089110592667962, 0.094620883979159, 0.096532352630054, 0.094620883979159, 0.089110592667962, 0.080630598589333, 0.070096874908772, 0.058549831524319}
})

local nonStandardGaussianPDFWindow = torch.Tensor({
    {0.000001452200915, 0.000000080797552, 0.000000000487159, 0.000000000000318, 0.000000000000000, 0.000000000000000, 0.000000000000000, 0.000000000000000, 0.000000000000000, 0.000000000000000, 0.000000000000000},
    {0.000240854107924, 0.000079287483413, 0.000002828501156, 0.000000010934760, 0.000000000004581, 0.000000000000000, 0.000000000000000, 0.000000000000000, 0.000000000000000, 0.000000000000000, 0.000000000000000},
    {0.004328949915153, 0.008431643111764, 0.001779684515109, 0.000040707551309, 0.000000100903931, 0.000000000027105, 0.000000000000001, 0.000000000000000, 0.000000000000000, 0.000000000000000, 0.000000000000000},
    {0.008431643111764, 0.097167482167606, 0.121347500208756, 0.016422598310807, 0.000240854107924, 0.000000382796005, 0.000000000065930, 0.000000000000001, 0.000000000000000, 0.000000000000000, 0.000000000000000},
    {0.001779684515109, 0.121347500208756, 0.896643486507501, 0.717975976728288, 0.062301883958987, 0.000585859662884, 0.000000597017644, 0.000000000065930, 0.000000000000001, 0.000000000000000, 0.000000000000000},
    {0.000040707551309, 0.016422598310807, 0.717975976728288, 3.401567607740293, 1.746423041360607, 0.097167482167607, 0.000585859662884, 0.000000382796005, 0.000000000027105, 0.000000000000000, 0.000000000000000},
    {0.000000100903931, 0.000240854107924, 0.062301883958987, 1.746423041360608, 5.305164769729846, 1.746423041360607, 0.062301883958987, 0.000240854107924, 0.000000100903931, 0.000000000004581, 0.000000000000000},
    {0.000000000027105, 0.000000382796005, 0.000585859662884, 0.097167482167607, 1.746423041360611, 3.401567607740294, 0.717975976728288, 0.016422598310807, 0.000040707551309, 0.000000010934760, 0.000000000000318},
    {0.000000000000001, 0.000000000065930, 0.000000597017644, 0.000585859662884, 0.062301883958987, 0.717975976728287, 0.896643486507500, 0.121347500208757, 0.001779684515109, 0.000002828501156, 0.000000000487159},
    {0.000000000000000, 0.000000000000001, 0.000000000065930, 0.000000382796005, 0.000240854107924, 0.016422598310807, 0.121347500208756, 0.097167482167606, 0.008431643111764, 0.000079287483413, 0.000000080797552},
    {0.000000000000000, 0.000000000000000, 0.000000000000001, 0.000000000027105, 0.000000100903931, 0.000040707551309, 0.001779684515109, 0.008431643111764, 0.004328949915153, 0.000240854107924, 0.000001452200915}
})

local nonStandardGaussianLogPDFWindow = torch.Tensor({
    -13.4424302802005, -16.3313191690894, -21.4424302802005, -28.7757636135338,
    -38.3313191690894, -50.1090969468671, -64.1090969468671, -80.3313191690893,
    -98.7757636135338, -119.4424302802, -142.331319169089, -8.33131916908937,
    -9.44243028020048, -12.7757636135338, -18.3313191690894, -26.1090969468671,
    -36.1090969468671, -48.3313191690894, -62.7757636135338, -79.4424302802005,
    -98.3313191690894, -119.4424302802, -5.44243028020048, -4.77576361353381,
    -6.33131916908937, -10.1090969468671, -16.1090969468671, -24.3313191690894,
    -34.7757636135338, -47.4424302802005, -62.3313191690893, -79.4424302802005,
    -98.7757636135338, -4.77576361353381, -2.33131916908936, -2.10909694686714,
    -4.10909694686714, -8.33131916908937, -14.7757636135338, -23.4424302802005,
    -34.3313191690894, -47.4424302802005, -62.7757636135338, -80.3313191690894,
    -6.33131916908936, -2.10909694686714, -0.109096946867141,
    -0.331319169089363, -2.77576361353381, -7.44243028020047,
    -14.3313191690894, -23.4424302802005, -34.7757636135338, -48.3313191690894,
    -64.1090969468671, -10.1090969468671, -4.10909694686714,
    -0.331319169089363, 1.22423638646619, 0.557569719799525, -2.33131916908936,
    -7.44243028020047, -14.7757636135338, -24.3313191690894, -36.1090969468671,
    -50.1090969468671, -16.1090969468671, -8.33131916908937, -2.77576361353381,
    0.557569719799526, 1.66868083091064, 0.557569719799525, -2.77576361353381,
    -8.33131916908936, -16.1090969468671, -26.1090969468671, -38.3313191690894,
    -24.3313191690894, -14.7757636135338, -7.44243028020047, -2.33131916908936,
    0.557569719799527, 1.22423638646619, -0.331319169089364, -4.10909694686714,
    -10.1090969468671, -18.3313191690894, -28.7757636135338, -34.7757636135338,
    -23.4424302802005, -14.3313191690894, -7.44243028020047, -2.77576361353381,
    -0.331319169089364, -0.109096946867142, -2.10909694686714,
    -6.33131916908936, -12.7757636135338, -21.4424302802005, -47.4424302802005,
    -34.3313191690894, -23.4424302802005, -14.7757636135338, -8.33131916908936,
    -4.10909694686714, -2.10909694686714, -2.33131916908936, -4.77576361353381,
    -9.44243028020047, -16.3313191690894, -62.3313191690893, -47.4424302802005,
    -34.7757636135338, -24.3313191690894, -16.1090969468671, -10.1090969468671,
    -6.33131916908937, -4.77576361353381, -5.44243028020048, -8.33131916908936,
    -13.4424302802005}):resize(121,1)
    
function myTests.multivariateGaussianPDF()

    -- Standard 2-d gaussian, singleton samples, no result tensor
    local D = 2
    local N = 11

    -- Points at which to evaluate the PDF
    local inputXs = torch.linspace(-1, 1, N)
    local result = torch.Tensor(N, N)
    local mu = torch.Tensor(D):fill(0)
    local sigma = torch.eye(D, D)

    local returnNumbers = true
    local expected = standardGaussianPDFWindow
    for i = 1, N do
        for j = 1, N do
            local x = torch.Tensor({inputXs[i], inputXs[j]}) -- One point
            local r = randomkit.multivariateGaussianPDF(x, mu, sigma)
            returnNumbers = returnNumbers and type(r) == 'number'
            result[i][j] = r
        end
    end
    tester:assert(returnNumbers, "should return a number when called with vectors only")
    tester:assertTensorEq(result, expected, 1e-15, "standard 2D gaussian pdf should match expected value")
end

function myTests.multivariateGaussianPDFNonStandard()

    -- Try calling D, D, D-D
    -- Non-standard 2-d gaussian, singleton samples, no result tensor
    local D = 2
    local N = 11

    -- Points at which to evaluate the PDF
    local inputXs = torch.linspace(-1, 1, N)
    local result = torch.Tensor(N, N)
    local mu = torch.Tensor({0.2, -0.2})
    local sigma = torch.Tensor({{0.05, 0.04}, {0.04, 0.05}})

    local expected = nonStandardGaussianPDFWindow

    local oldMu = mu:clone()
    local oldSigma = sigma:clone()

    local returnNumbers = true
    for i = 1, N do
        for j = 1, N do
            local x = torch.Tensor({inputXs[i], inputXs[j]}) -- One point
            local r = randomkit.multivariateGaussianPDF(x, mu, sigma)
            returnNumbers = returnNumbers and type(r) == 'number'
            result[i][j] = r
        end
    end
    tester:assertTensorEq(mu, oldMu, 1e-14, "multivariateGaussianPDF should not modify sigma")
    tester:assertTensorEq(sigma, oldSigma, 1e-14, "multivariateGaussianPDF should not modify sigma")
    tester:assert(returnNumbers, "should return a number when called with vectors only")
    tester:assertTensorEq(result, expected, 1e-14, "non-standard 2D gaussian pdf should match expected value")
end

-- Try calling NxD, D, DxD
function myTests.multivariateGaussianPDFMultiple1()

    -- Standard 2-d gaussian, multiple samples, no result tensor
    local D = 2
    local N = 11

    -- Points at which to evaluate the PDF
    local inputXs = torch.linspace(-1, 1, N)
    local mu = torch.Tensor({0.2, -0.2})
    local sigma = torch.Tensor({{0.05, 0.04}, {0.04, 0.05}})

    local x = torch.Tensor(N*N, D)
    local expected = torch.Tensor(N*N, 1)
    for i = 1, N do
        for j = 1, N do
            x[(i-1)*N+j][1] = inputXs[i]
            x[(i-1)*N+j][2] = inputXs[j]
            expected[(i-1)*N+j] = nonStandardGaussianPDFWindow[i][j]
        end
    end

    tester:assertTensorEq(randomkit.multivariateGaussianPDF(x, mu, sigma), expected, 1e-14, "non-standard 2D gaussian pdf should match expected value")
end

-- Try calling 1xD, D, DxD
function myTests.multivariateGaussianPDFMultiple2()
    local x = torch.Tensor({{0, 0}})
    local mu = torch.Tensor({0.2, -0.2})
    local sigma = torch.Tensor({{0.05, 0.04}, {0.04, 0.05}})
    local expected = torch.Tensor({{nonStandardGaussianPDFWindow[6][6]}})
    local got = randomkit.multivariateGaussianPDF(x, mu, sigma)
    tester:assertTensorEq(randomkit.multivariateGaussianPDF(x, mu, sigma), got, 1e-14, "multivariateGaussianPDF should not modify args")
    tester:assertTensorEq(got, expected, 1e-14, "non-standard 2D gaussian pdf should match expected value")
end

-- Try calling D, 1xD, DxD
function myTests.multivariateGaussianPDFMultiple3()
    local x = torch.Tensor({0, 0})
    local mu = torch.Tensor({{-0.2, 0.2}})
    local sigma = torch.Tensor({{0.05, 0.04}, {0.04, 0.05}})
    local expected = torch.Tensor({{nonStandardGaussianPDFWindow[6][6]}})
    local got = randomkit.multivariateGaussianPDF(x, mu, sigma)
    tester:assertTensorEq(got, expected, 1e-14, "non-standard 2D gaussian pdf should match expected value")
end

-- Try calling D, NxD, DxD
function myTests.multivariateGaussianPDFMultiple4()
    local x = torch.Tensor({0, 0})
    local mu = torch.Tensor({{-0.2, 0.2}, {-0.4, 0.4}, {0.0, 0.0}})
    local sigma = torch.Tensor({{0.05, 0.04}, {0.04, 0.05}})
    local expected = torch.Tensor({{nonStandardGaussianPDFWindow[6][6]}, {0.000000597017644}, {5.305164769729846}})
    local got = randomkit.multivariateGaussianPDF(x, mu, sigma)
    tester:assertTensorEq(got, expected, 1e-14, "non-standard 2D gaussian pdf should match expected value")
end

-- Now with diagonal covariance only
-- Try calling D, D, D
function myTests.multivariateGaussianPDFMultiple5()
    local x = torch.Tensor({0, 0})
    local mu = torch.Tensor({-0.2, 0.2})
    local sigma = torch.Tensor({0.05, 0.4})
    local expected = 0.717583785682725
    local got = randomkit.multivariateGaussianPDF(x, mu, sigma)
    tester:assertalmosteq(got, expected, 1e-14, "non-standard 2D gaussian pdf should match expected value")
end

-- Try calling D, 1-D, D
function myTests.multivariateGaussianPDFMultiple6()
    local x = torch.Tensor({0, 0})
    local mu = torch.Tensor({{-0.2, 0.2}})
    local sigma = torch.Tensor({0.05, 0.4})
    local expected = torch.Tensor({0.717583785682725})
    local got = randomkit.multivariateGaussianPDF(x, mu, sigma)
    tester:assertTensorEq(got, expected, 1e-14, "non-standard 2D gaussian pdf should match expected value")
end

-- Try calling D, NxD, D
function myTests.multivariateGaussianPDFMultiple7()
    local x = torch.Tensor({0, 0})
    local mu = torch.Tensor({{-0.2, 0.2}, {-0.4, 0.4}, {0.0, 0.0}})
    local sigma = torch.Tensor({0.05, 0.4})
    local expected = torch.Tensor({0.717583785682725, 0.186026607635655, 1.125395395196383})
    local got = randomkit.multivariateGaussianPDF(x, mu, sigma)
    tester:assertTensorEq(got, expected, 1e-14, "non-standard 2D gaussian pdf should match expected value")
end

-- Try calling 1xD, D, D
function myTests.multivariateGaussianPDFMultiple8()
    local x = torch.Tensor({{0, 0}})
    local mu = torch.Tensor({-0.2, 0.2})
    local sigma = torch.Tensor({0.05, 0.4})
    local expected = torch.Tensor({0.717583785682725})
    local got = randomkit.multivariateGaussianPDF(x, mu, sigma)
    tester:assertTensorEq(got, expected, 1e-14, "non-standard 2D gaussian pdf should match expected value")
end

-- Try calling NxD, D, D
function myTests.multivariateGaussianPDFMultiple9()
    local x = torch.Tensor({{0, 0}, {0.1, 0.2}, {-0.3, -0.1}})
    local mu = torch.Tensor({-0.2, 0.2})
    local sigma = torch.Tensor({0.05, 0.4})
    local expected = torch.Tensor({0.717583785682725, 0.457551622898630, 0.909950056726693})
    local got = randomkit.multivariateGaussianPDF(x, mu, sigma)
    tester:assertTensorEq(got, expected, 1e-14, "non-standard 2D gaussian pdf should match expected value")
end

-- Same with result as first element
-- TODO

function myTests.multivariateGaussianLogPDFNonStandard()

    -- Try calling D, D, D-D
    -- Non-standard 2-d gaussian, singleton samples, no result tensor
    local D = 2
    local N = 11

    -- Points at which to evaluate the PDF
    local inputXs = torch.linspace(-1, 1, N)
    local result = torch.Tensor(N, N)
    local mu = torch.Tensor({0.2, -0.2})
    local sigma = torch.Tensor({{0.05, 0.04}, {0.04, 0.05}})

    local expected = nonStandardGaussianLogPDFWindow

    local returnNumbers = true
    for i = 1, N do
        for j = 1, N do
            local x = torch.Tensor({inputXs[i], inputXs[j]}) -- One point
            local r = randomkit.multivariateGaussianLogPDF(x, mu, sigma)
            returnNumbers = returnNumbers and type(r) == 'number'
            result[i][j] = r
        end
    end
    tester:assert(returnNumbers, "should return a number when called with vectors only")
    tester:assertTensorEq(result, expected, 1e-12, "non-standard 2D gaussian log-pdf should match expected value")
end

tester:add(myTests)
tester:run()