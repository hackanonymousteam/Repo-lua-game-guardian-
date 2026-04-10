
class Value {
    constructor(data) {
        this.data = typeof data === 'number' ? data : 0
        this.grad = 0
        this._backward = () => {}
        this._prev = []
        this._op = ''
    }

    add(other) {
        other = other instanceof Value ? other : new Value(other)
        const out = new Value(this.data + other.data)
        out._prev = [this, other]
        out._op = '+'
        out._backward = () => {
            this.grad += out.grad
            other.grad += out.grad
        }
        return out
    }

    mul(other) {
        other = other instanceof Value ? other : new Value(other)
        const out = new Value(this.data * other.data)
        out._prev = [this, other]
        out._op = '*'
        out._backward = () => {
            this.grad += other.data * out.grad
            other.grad += this.data * out.grad
        }
        return out
    }

    sub(other) {
        return this.add(other instanceof Value ? other.neg() : new Value(-other))
    }

    div(other) {
        return this.mul(other instanceof Value ? other.pow(-1) : 1 / other)
    }

    pow(other) {
        const out = new Value(Math.pow(this.data, other))
        out._prev = [this]
        out._op = `^${other}`
        out._backward = () => {
            this.grad += other * Math.pow(this.data, other - 1) * out.grad
        }
        return out
    }

    neg() {
        return this.mul(-1)
    }

    exp() {
        const out = new Value(Math.exp(this.data))
        out._prev = [this]
        out._op = 'exp'
        out._backward = () => {
            this.grad += out.data * out.grad
        }
        return out
    }

    log() {
        const out = new Value(Math.log(this.data))
        out._prev = [this]
        out._op = 'log'
        out._backward = () => {
            this.grad += (1 / this.data) * out.grad
        }
        return out
    }

    relu() {
        const out = new Value(this.data > 0 ? this.data : 0)
        out._prev = [this]
        out._op = 'relu'
        out._backward = () => {
            this.grad += (this.data > 0 ? out.grad : 0)
        }
        return out
    }

    tanh() {
        const t = Math.tanh(this.data)
        const out = new Value(t)
        out._prev = [this]
        out._op = 'tanh'
        out._backward = () => {
            this.grad += (1 - t * t) * out.grad
        }
        return out
    }

    sigmoid() {
        const s = 1 / (1 + Math.exp(-this.data))
        const out = new Value(s)
        out._prev = [this]
        out._op = 'sigmoid'
        out._backward = () => {
            this.grad += s * (1 - s) * out.grad
        }
        return out
    }

    backward() {
        const topo = []
        const visited = new Set()
        const build = (v) => {
            if (!visited.has(v)) {
                visited.add(v)
                v._prev.forEach(build)
                topo.push(v)
            }
        }
        build(this)
        topo.reverse()
        this.grad = 1
        topo.forEach(v => v._backward())
    }

    zeroGrad() {
        const clear = (v) => {
            v.grad = 0
            v._prev.forEach(clear)
        }
        clear(this)
    }
}

// ==================== NUMERIC TENSOR ====================
class Tensor {
    constructor(data, shape = null) {
        this.data = Array.isArray(data) ? data.flat(Infinity) : [data]
        this.shape = shape || [this.data.length]
        this.size = this.shape.reduce((a, b) => a * b, 1)
        if (this.size !== this.data.length) throw new Error('Shape mismatch')
    }

    static zeros(shape) {
        return new Tensor(new Array(shape.reduce((a, b) => a * b, 1)).fill(0), shape)
    }

    static ones(shape) {
        return new Tensor(new Array(shape.reduce((a, b) => a * b, 1)).fill(1), shape)
    }

    static randn(shape, mean = 0, std = 0.1) {
        const size = shape.reduce((a, b) => a * b, 1)
        const data = new Array(size)
        for (let i = 0; i < size; i++) {
            data[i] = mean + (Math.random() * 2 - 1) * std
        }
        return new Tensor(data, shape)
    }

    static eye(n) {
        const data = new Array(n * n).fill(0)
        for (let i = 0; i < n; i++) data[i * n + i] = 1
        return new Tensor(data, [n, n])
    }

    static arange(start, end, step = 1) {
        const data = []
        for (let i = start; i < end; i += step) data.push(i)
        return new Tensor(data)
    }

    add(other) {
        if (other instanceof Tensor) {
            if (this.data.length !== other.data.length) throw new Error('Size mismatch')
            const result = new Array(this.data.length)
            for (let i = 0; i < this.data.length; i++) result[i] = this.data[i] + other.data[i]
            return new Tensor(result, this.shape)
        }
        const result = new Array(this.data.length)
        for (let i = 0; i < this.data.length; i++) result[i] = this.data[i] + other
        return new Tensor(result, this.shape)
    }

    sub(other) {
        if (other instanceof Tensor) {
            if (this.data.length !== other.data.length) throw new Error('Size mismatch')
            const result = new Array(this.data.length)
            for (let i = 0; i < this.data.length; i++) result[i] = this.data[i] - other.data[i]
            return new Tensor(result, this.shape)
        }
        const result = new Array(this.data.length)
        for (let i = 0; i < this.data.length; i++) result[i] = this.data[i] - other
        return new Tensor(result, this.shape)
    }

    mul(other) {
        if (other instanceof Tensor) {
            if (this.data.length !== other.data.length) throw new Error('Size mismatch')
            const result = new Array(this.data.length)
            for (let i = 0; i < this.data.length; i++) result[i] = this.data[i] * other.data[i]
            return new Tensor(result, this.shape)
        }
        const result = new Array(this.data.length)
        for (let i = 0; i < this.data.length; i++) result[i] = this.data[i] * other
        return new Tensor(result, this.shape)
    }

    div(other) {
        if (other instanceof Tensor) {
            if (this.data.length !== other.data.length) throw new Error('Size mismatch')
            const result = new Array(this.data.length)
            for (let i = 0; i < this.data.length; i++) result[i] = this.data[i] / other.data[i]
            return new Tensor(result, this.shape)
        }
        const result = new Array(this.data.length)
        for (let i = 0; i < this.data.length; i++) result[i] = this.data[i] / other
        return new Tensor(result, this.shape)
    }

    dot(other) {
        if (this.shape.length !== 2 || other.shape.length !== 2) {
            throw new Error('Dot product requires 2D tensors')
        }
        if (this.shape[1] !== other.shape[0]) {
            throw new Error('Shape mismatch for dot product')
        }
        
        const m = this.shape[0]
        const n = this.shape[1]
        const p = other.shape[1]
        const result = new Array(m * p).fill(0)
        
        for (let i = 0; i < m; i++) {
            for (let j = 0; j < p; j++) {
                let sum = 0
                for (let k = 0; k < n; k++) {
                    sum += this.data[i * n + k] * other.data[k * p + j]
                }
                result[i * p + j] = sum
            }
        }
        
        return new Tensor(result, [m, p])
    }

    sum(axis = null) {
        if (axis === null) {
            let total = 0
            for (let i = 0; i < this.data.length; i++) total += this.data[i]
            return total
        }
        
        throw new Error('Axis sum not implemented')
    }

    mean() {
        return this.sum() / this.data.length
    }

    std() {
        const mean = this.mean()
        let variance = 0
        for (let i = 0; i < this.data.length; i++) {
            variance += Math.pow(this.data[i] - mean, 2)
        }
        return Math.sqrt(variance / this.data.length)
    }

    T() {
        if (this.shape.length < 2) return this
        const rows = this.shape[0]
        const cols = this.shape[1]
        const result = new Array(this.data.length)
        for (let i = 0; i < rows; i++) {
            for (let j = 0; j < cols; j++) {
                result[j * rows + i] = this.data[i * cols + j]
            }
        }
        return new Tensor(result, [cols, rows])
    }

    reshape(newShape) {
        const size = newShape.reduce((a, b) => a * b, 1)
        if (size !== this.data.length) throw new Error('Invalid reshape')
        return new Tensor([...this.data], newShape)
    }

    flatten() {
        return new Tensor([...this.data], [this.data.length])
    }

    slice(start, end) {
        return new Tensor(this.data.slice(start, end), [end - start])
    }

    toString() {
        return `Tensor(shape=[${this.shape}])`
    }
}

// ==================== DATA PROCESSING ====================
class Scaler {
    constructor() {
        this.mean = null
        this.std = null
        this.min = null
        this.max = null
        this.fitted = false
    }

    fit(data) {
        const n = data.length
        const d = data[0].length
        this.mean = new Array(d).fill(0)
        this.std = new Array(d).fill(0)
        this.min = new Array(d).fill(Infinity)
        this.max = new Array(d).fill(-Infinity)
        
        // Primeira passada: min, max e média
        for (let j = 0; j < d; j++) {
            let sum = 0
            for (let i = 0; i < n; i++) {
                const val = data[i][j]
                sum += val
                this.min[j] = Math.min(this.min[j], val)
                this.max[j] = Math.max(this.max[j], val)
            }
            this.mean[j] = sum / n
        }
        
        // Segunda passada: desvio padrão
        for (let j = 0; j < d; j++) {
            let sqSum = 0
            for (let i = 0; i < n; i++) {
                sqSum += Math.pow(data[i][j] - this.mean[j], 2)
            }
            this.std[j] = Math.sqrt(sqSum / n) || 1
        }
        
        this.fitted = true
        return this
    }

    transform(data) {
        if (!this.fitted) throw new Error('Scaler not fitted')
        
        const n = data.length
        const d = data[0].length
        const result = []
        
        for (let i = 0; i < n; i++) {
            const row = []
            for (let j = 0; j < d; j++) {
                row.push((data[i][j] - this.mean[j]) / this.std[j])
            }
            result.push(row)
        }
        
        return result
    }

    fitTransform(data) {
        this.fit(data)
        return this.transform(data)
    }

    inverseTransform(data) {
        if (!this.fitted) throw new Error('Scaler not fitted')
        
        const n = data.length
        const d = data[0].length
        const result = []
        
        for (let i = 0; i < n; i++) {
            const row = []
            for (let j = 0; j < d; j++) {
                row.push(data[i][j] * this.std[j] + this.mean[j])
            }
            result.push(row)
        }
        
        return result
    }
}

// ==================== ML MODELS (CLASSICAL) ====================
class KMeans {
    constructor(k = 3) {
        this.k = k
        this.centroids = null
        this.labels = null
        this.inertia = 0
        this.scaler = new Scaler()
        this.fitted = false
    }

    _distance(a, b) {
        let sum = 0
        for (let i = 0; i < a.length; i++) sum += Math.pow(a[i] - b[i], 2)
        return Math.sqrt(sum)
    }

    _initCentroids(data) {
        const centroids = []
        // Primeiro centro aleatório
        centroids.push([...data[Math.floor(Math.random() * data.length)]])
        
        // K-means++ para os demais
        for (let i = 1; i < this.k; i++) {
            const dists = data.map(point => {
                let minDist = Infinity
                for (const centroid of centroids) {
                    const dist = this._distance(point, centroid)
                    if (dist < minDist) minDist = dist
                }
                return minDist * minDist
            })
            
            const total = dists.reduce((a, b) => a + b, 0)
            let r = Math.random() * total
            for (let j = 0; j < data.length; j++) {
                r -= dists[j]
                if (r <= 0) {
                    centroids.push([...data[j]])
                    break
                }
            }
        }
        
        return centroids
    }

    fit(data) {
        const scaled = this.scaler.fitTransform(data)
        const n = scaled.length
        const d = scaled[0].length
        
        this.centroids = this._initCentroids(scaled)
        
        for (let iter = 0; iter < 100; iter++) {
            // Assign clusters
            this.labels = new Array(n)
            const counts = new Array(this.k).fill(0)
            const sums = new Array(this.k).fill().map(() => new Array(d).fill(0))
            
            for (let i = 0; i < n; i++) {
                let bestCluster = 0
                let minDist = Infinity
                
                for (let j = 0; j < this.k; j++) {
                    const dist = this._distance(scaled[i], this.centroids[j])
                    if (dist < minDist) {
                        minDist = dist
                        bestCluster = j
                    }
                }
                
                this.labels[i] = bestCluster
                counts[bestCluster]++
                for (let dim = 0; dim < d; dim++) {
                    sums[bestCluster][dim] += scaled[i][dim]
                }
            }
            
            // Update centroids
            let moved = 0
            for (let j = 0; j < this.k; j++) {
                if (counts[j] > 0) {
                    const newCentroid = sums[j].map(val => val / counts[j])
                    if (this._distance(newCentroid, this.centroids[j]) > 1e-4) moved++
                    this.centroids[j] = newCentroid
                } else {
                    // Reinitialize empty cluster
                    this.centroids[j] = scaled[Math.floor(Math.random() * n)]
                    moved++
                }
            }
            
            if (moved === 0) break
        }
        
        // Calculate inertia
        this.inertia = 0
        for (let i = 0; i < n; i++) {
            this.inertia += Math.pow(
                this._distance(scaled[i], this.centroids[this.labels[i]]), 
                2
            )
        }
        
        this.fitted = true
        return this
    }

    predict(data) {
        if (!this.fitted) throw new Error('Model not fitted')
        
        const scaled = this.scaler.transform(data)
        return scaled.map(point => {
            let bestCluster = 0
            let minDist = Infinity
            
            for (let j = 0; j < this.k; j++) {
                const dist = this._distance(point, this.centroids[j])
                if (dist < minDist) {
                    minDist = dist
                    bestCluster = j
                }
            }
            
            return bestCluster
        })
    }

    score() {
        if (!this.fitted) return 0
        const normalizedInertia = this.inertia / (this.labels.length * 10)
        return Math.max(0, 1 - normalizedInertia)
    }

    getClusterStats() {
        if (!this.fitted) return null
        
        const stats = []
        for (let i = 0; i < this.k; i++) {
            const indices = this.labels.map((label, idx) => label === i ? idx : -1)
                .filter(idx => idx !== -1)
            stats.push({
                cluster: i,
                size: indices.length,
                centroid: this.scaler.inverseTransform([this.centroids[i]])[0]
            })
        }
        
        return stats
    }
}

class DBSCAN {
    constructor(eps = 0.5, minPts = 5) {
        this.eps = eps
        this.minPts = minPts
        this.labels = null
        this.corePoints = []
        this.coreSamples = []
        this.scaler = new Scaler()
        this.fitted = false
    }

    _distance(a, b) {
        let sum = 0
        for (let i = 0; i < a.length; i++) sum += Math.pow(a[i] - b[i], 2)
        return Math.sqrt(sum)
    }

    fit(data) {
        const scaled = this.scaler.fitTransform(data)
        const n = scaled.length
        this.labels = new Array(n).fill(-1)
        this.corePoints = []
        this.coreSamples = []
        
        let clusterId = 0
        
        const regionQuery = (pointIdx) => {
            const neighbors = []
            for (let i = 0; i < n; i++) {
                if (this._distance(scaled[pointIdx], scaled[i]) <= this.eps) {
                    neighbors.push(i)
                }
            }
            return neighbors
        }
        
        const expandCluster = (pointIdx, neighbors, clusterId) => {
            this.labels[pointIdx] = clusterId
            
            for (let i = 0; i < neighbors.length; i++) {
                const neighborIdx = neighbors[i]
                
                if (this.labels[neighborIdx] === -1) {
                    this.labels[neighborIdx] = clusterId
                    const neighborNeighbors = regionQuery(neighborIdx)
                    
                    if (neighborNeighbors.length >= this.minPts) {
                        this.corePoints.push(neighborIdx)
                        this.coreSamples.push(scaled[neighborIdx])
                        neighbors.push(...neighborNeighbors)
                    }
                }
            }
        }
        
        for (let i = 0; i < n; i++) {
            if (this.labels[i] !== -1) continue
            
            const neighbors = regionQuery(i)
            
            if (neighbors.length < this.minPts) {
                this.labels[i] = -1  // Noise
            } else {
                this.corePoints.push(i)
                this.coreSamples.push(scaled[i])
                expandCluster(i, neighbors, clusterId)
                clusterId++
            }
        }
        
        this.fitted = true
        return this
    }

    predict(data) {
        if (!this.fitted) throw new Error('Model not fitted')
        
        const scaled = this.scaler.transform(data)
        return scaled.map(point => {
            let minDist = Infinity
            let bestLabel = -1
            
            for (let i = 0; i < this.coreSamples.length; i++) {
                const dist = this._distance(point, this.coreSamples[i])
                if (dist < minDist) {
                    minDist = dist
                    bestLabel = this.labels[this.corePoints[i]]
                }
            }
            
            return bestLabel
        })
    }

    score() {
        if (!this.fitted) return 0
        
        const n = this.labels.length
        const noiseCount = this.labels.filter(l => l === -1).length
        const clusterCount = new Set(this.labels.filter(l => l !== -1)).size
        
        if (clusterCount < 1) return 0
        
        const coverage = (n - noiseCount) / n
        const noiseRatio = noiseCount / n
        
        return Math.max(0, coverage - noiseRatio * 0.5)
    }

    getClusterStats() {
        if (!this.fitted) return null
        
        const clusters = {}
        for (let i = 0; i < this.labels.length; i++) {
            const label = this.labels[i]
            if (label !== -1) {
                if (!clusters[label]) clusters[label] = []
                clusters[label].push(i)
            }
        }
        
        const stats = []
        for (const [label, indices] of Object.entries(clusters)) {
            stats.push({
                cluster: parseInt(label),
                size: indices.length
            })
        }
        
        return stats
    }
}

class DecisionNode {
    constructor(feature = null, threshold = null, left = null, right = null, value = null) {
        this.feature = feature
        this.threshold = threshold
        this.left = left
        this.right = right
        this.value = value
        this.isLeaf = value !== null
    }
}

class DecisionTree {
    constructor(maxDepth = 10, minSamplesSplit = 2, minSamplesLeaf = 1, seed = 42) {
        this.maxDepth = maxDepth
        this.minSamplesSplit = minSamplesSplit
        this.minSamplesLeaf = minSamplesLeaf
        this.seed = seed
        this.root = null
        this.fitted = false
        this.rng = this._createRNG(seed)
    }

    _createRNG(seed) {
        let state = seed
        return () => {
            state = (state * 9301 + 49297) % 233280
            return state / 233280
        }
    }

    _gini(y) {
        const counts = {}
        for (const label of y) {
            counts[label] = (counts[label] || 0) + 1
        }
        
        let impurity = 1
        const n = y.length
        for (const count of Object.values(counts)) {
            impurity -= Math.pow(count / n, 2)
        }
        
        return impurity
    }

    _entropy(y) {
        const counts = {}
        for (const label of y) {
            counts[label] = (counts[label] || 0) + 1
        }
        
        let entropy = 0
        const n = y.length
        for (const count of Object.values(counts)) {
            const p = count / n
            if (p > 0) entropy -= p * Math.log2(p)
        }
        
        return entropy
    }

    _bestSplit(X, y, criterion = 'gini') {
        const n = X.length
        const m = X[0].length
        let bestGain = -Infinity
        let bestFeature = null
        let bestThreshold = null
        
        const criterionFunc = criterion === 'gini' ? this._gini.bind(this) : this._entropy.bind(this)
        const parentImpurity = criterionFunc(y)
        
        // Amostragem aleatória de features
        const maxFeatures = Math.max(1, Math.floor(Math.sqrt(m)))
        const featureIndices = Array.from({length: m}, (_, i) => i)
        for (let i = m - 1; i > 0; i--) {
            const j = Math.floor(this.rng() * (i + 1))
            ;[featureIndices[i], featureIndices[j]] = [featureIndices[j], featureIndices[i]]
        }
        
        for (let idx = 0; idx < maxFeatures; idx++) {
            const feature = featureIndices[idx]
            const values = X.map(row => row[feature])
            const unique = [...new Set(values)].sort((a, b) => a - b)
            
            if (unique.length <= 1) continue
            
            const maxThresholds = Math.min(unique.length - 1, 10)
            for (let t = 0; t < maxThresholds; t++) {
                const thresholdIdx = Math.floor(this.rng() * (unique.length - 1)) + 1
                const threshold = (unique[thresholdIdx - 1] + unique[thresholdIdx]) / 2
                
                // Particionar dados
                const leftY = [], rightY = []
                for (let i = 0; i < n; i++) {
                    if (X[i][feature] <= threshold) leftY.push(y[i])
                    else rightY.push(y[i])
                }
                
                if (leftY.length < this.minSamplesLeaf || rightY.length < this.minSamplesLeaf) {
                    continue
                }
                
                // Calcular ganho
                const leftImpurity = criterionFunc(leftY)
                const rightImpurity = criterionFunc(rightY)
                const gain = parentImpurity - 
                    (leftY.length / n) * leftImpurity - 
                    (rightY.length / n) * rightImpurity
                
                if (gain > bestGain) {
                    bestGain = gain
                    bestFeature = feature
                    bestThreshold = threshold
                }
            }
        }
        
        return [bestGain, bestFeature, bestThreshold]
    }

    _buildTree(X, y, depth = 0, criterion = 'gini') {
        const n = X.length
        const uniqueClasses = [...new Set(y)]
        
        // Critérios de parada
        if (depth >= this.maxDepth || 
            n < this.minSamplesSplit || 
            uniqueClasses.length === 1) {
            // Classe majoritária
            const counts = {}
            for (const label of y) counts[label] = (counts[label] || 0) + 1
            let majorityClass = null
            let maxCount = -1
            for (const [cls, count] of Object.entries(counts)) {
                if (count > maxCount) {
                    maxCount = count
                    majorityClass = cls
                }
            }
            return new DecisionNode(null, null, null, null, majorityClass)
        }
        
        const [gain, feature, threshold] = this._bestSplit(X, y, criterion)
        
        if (gain <= 0) {
            const counts = {}
            for (const label of y) counts[label] = (counts[label] || 0) + 1
            let majorityClass = null
            let maxCount = -1
            for (const [cls, count] of Object.entries(counts)) {
                if (count > maxCount) {
                    maxCount = count
                    majorityClass = cls
                }
            }
            return new DecisionNode(null, null, null, null, majorityClass)
        }
        
        // Particionar dados
        const leftX = [], leftY = [], rightX = [], rightY = []
        for (let i = 0; i < n; i++) {
            if (X[i][feature] <= threshold) {
                leftX.push(X[i])
                leftY.push(y[i])
            } else {
                rightX.push(X[i])
                rightY.push(y[i])
            }
        }
        
        const left = this._buildTree(leftX, leftY, depth + 1, criterion)
        const right = this._buildTree(rightX, rightY, depth + 1, criterion)
        
        return new DecisionNode(feature, threshold, left, right)
    }

    fit(X, y, criterion = 'gini') {
        this.root = this._buildTree(X, y, 0, criterion)
        this.fitted = true
        return this
    }

    _predictSingle(node, x) {
        if (node.isLeaf) return node.value
        if (x[node.feature] <= node.threshold) {
            return this._predictSingle(node.left, x)
        }
        return this._predictSingle(node.right, x)
    }

    predict(X) {
        if (!this.fitted) throw new Error('Model not fitted')
        return X.map(x => this._predictSingle(this.root, x))
    }

    score(X, y) {
        if (!this.fitted) return 0
        const predictions = this.predict(X)
        let correct = 0
        for (let i = 0; i < y.length; i++) {
            if (predictions[i] === y[i]) correct++
        }
        return correct / y.length
    }

    getDepth() {
        const getNodeDepth = (node) => {
            if (node.isLeaf) return 1
            return 1 + Math.max(getNodeDepth(node.left), getNodeDepth(node.right))
        }
        return this.fitted ? getNodeDepth(this.root) : 0
    }
}

// ==================== ENSEMBLE MODELS ====================
class RandomForest {
    constructor(nEstimators = 10, maxDepth = 10, minSamplesSplit = 2, seed = 42) {
        this.nEstimators = nEstimators
        this.maxDepth = maxDepth
        this.minSamplesSplit = minSamplesSplit
        this.seed = seed
        this.trees = []
        this.fitted = false
    }

    fit(X, y) {
        this.trees = []
        const n = X.length
        
        for (let i = 0; i < this.nEstimators; i++) {
            // Bootstrap sample
            const indices = []
            for (let j = 0; j < n; j++) {
                indices.push(Math.floor(Math.random() * n))
            }
            
            const XSample = indices.map(idx => X[idx])
            const ySample = indices.map(idx => y[idx])
            
            const tree = new DecisionTree(
                this.maxDepth,
                this.minSamplesSplit,
                1,
                this.seed + i
            )
            
            tree.fit(XSample, ySample)
            this.trees.push(tree)
        }
        
        this.fitted = true
        return this
    }

    predict(X) {
        if (!this.fitted) throw new Error('Model not fitted')
        
        const predictions = X.map(x => {
            const votes = {}
            for (const tree of this.trees) {
                const pred = tree.predict([x])[0]
                votes[pred] = (votes[pred] || 0) + 1
            }
            
            let bestClass = null
            let maxVotes = -1
            for (const [cls, count] of Object.entries(votes)) {
                if (count > maxVotes) {
                    maxVotes = count
                    bestClass = cls
                }
            }
            
            return bestClass
        })
        
        return predictions
    }

    score(X, y) {
        if (!this.fitted) return 0
        const preds = this.predict(X)
        let correct = 0
        for (let i = 0; i < y.length; i++) {
            if (preds[i] === y[i]) correct++
        }
        return correct / y.length
    }
}

// ==================== EXPERIMENTAL (DL) ====================
class Experimental {
    static NeuralNetwork(layers) {
        console.warn('Experimental: Neural networks use Tensor (no autograd)')
        return {
            layers,
            predict: (X) => {
                let tensor = new Tensor(X, [X.length, X[0].length])
                for (const layer of layers) {
                    tensor = tensor.dot(layer.weights).add(layer.bias)
                }
                // Simple argmax
                const predictions = []
                for (let i = 0; i < tensor.shape[0]; i++) {
                    const start = i * tensor.shape[1]
                    const row = tensor.data.slice(start, start + tensor.shape[1])
                    predictions.push(row.indexOf(Math.max(...row)))
                }
                return predictions
            }
        }
    }

    static LinearLayer(inputSize, outputSize) {
        return {
            weights: Tensor.randn([inputSize, outputSize]),
            bias: Tensor.zeros([outputSize])
        }
    }
}

// ==================== METRIC SYSTEM ====================
class Metrics {
    static accuracy(yTrue, yPred) {
        let correct = 0
        for (let i = 0; i < yTrue.length; i++) {
            if (yTrue[i] === yPred[i]) correct++
        }
        return correct / yTrue.length
    }

    static silhouetteScore(data, labels) {
        const n = data.length
        const uniqueLabels = [...new Set(labels)]
        
        if (uniqueLabels.length < 2) return 0
        
        const distance = (a, b) => {
            let sum = 0
            for (let i = 0; i < a.length; i++) sum += Math.pow(a[i] - b[i], 2)
            return Math.sqrt(sum)
        }
        
        let totalScore = 0
        let validSamples = 0
        
        for (let i = 0; i < n; i++) {
            const currentLabel = labels[i]
            const currentPoint = data[i]
            
            // Distância intra-cluster
            let intraDist = 0
            let intraCount = 0
            
            // Distância inter-cluster
            const interDists = {}
            
            for (let j = 0; j < n; j++) {
                if (i === j) continue
                
                const dist = distance(currentPoint, data[j])
                const neighborLabel = labels[j]
                
                if (neighborLabel === currentLabel) {
                    intraDist += dist
                    intraCount++
                } else {
                    if (!interDists[neighborLabel]) {
                        interDists[neighborLabel] = {sum: 0, count: 0}
                    }
                    interDists[neighborLabel].sum += dist
                    interDists[neighborLabel].count++
                }
            }
            
            if (intraCount === 0) continue
            
            const a = intraDist / intraCount
            
            let b = Infinity
            for (const {sum, count} of Object.values(interDists)) {
                if (count > 0) {
                    const avg = sum / count
                    if (avg < b) b = avg
                }
            }
            
            if (b === Infinity) continue
            
            const s = (b - a) / Math.max(a, b)
            totalScore += s
            validSamples++
        }
        
        return validSamples > 0 ? totalScore / validSamples : 0
    }

    static adjustedRandScore(labels1, labels2) {
        // Contingency matrix
        const unique1 = [...new Set(labels1)]
        const unique2 = [...new Set(labels2)]
        
        const n = labels1.length
        const contingency = Array(unique1.length).fill()
            .map(() => Array(unique2.length).fill(0))
        
        const index1 = {}
        const index2 = {}
        unique1.forEach((l, i) => index1[l] = i)
        unique2.forEach((l, i) => index2[l] = i)
        
        for (let i = 0; i < n; i++) {
            const idx1 = index1[labels1[i]]
            const idx2 = index2[labels2[i]]
            contingency[idx1][idx2]++
        }
        
        // Sums
        const sumRows = contingency.map(row => row.reduce((a, b) => a + b, 0))
        const sumCols = contingency[0].map((_, j) => 
            contingency.reduce((sum, row) => sum + row[j], 0))
        
        // Calculate indices
        const sumNij = contingency.reduce((total, row) => 
            total + row.reduce((rowSum, nij) => rowSum + nij * (nij - 1) / 2, 0), 0)
        
        const sumAi = sumRows.reduce((total, ai) => total + ai * (ai - 1) / 2, 0)
        const sumBj = sumCols.reduce((total, bj) => total + bj * (bj - 1) / 2, 0)
        
        const nC2 = n * (n - 1) / 2
        const expected = (sumAi * sumBj) / nC2
        const max = (sumAi + sumBj) / 2
        
        if (max - expected === 0) return 1
        
        return (sumNij - expected) / (max - expected)
    }
}

// ==================== MEMORY SYSTEM ====================
class Memory {
    constructor(maxSize = 1000) {
        this.data = []
        this.maxSize = maxSize
    }

    push(record) {
        this.data.push(record)
        if (this.data.length > this.maxSize) this.data.shift()
    }

    size() {
        return this.data.length
    }

    clear() {
        this.data = []
    }

    findSimilar(task, k = 3) {
        if (this.data.length === 0) return []
        
        // Melhor métrica de similaridade
        const scores = this.data.map(record => {
            // Similaridade baseada em múltiplos fatores
            const sizeSimilarity = 1 - Math.abs(record.size - task.size) / Math.max(record.size, task.size)
            const dimSimilarity = 1 - Math.abs(record.dimensions - task.dimensions) / Math.max(record.dimensions, task.dimensions)
            const typeSimilarity = record.taskType === task.taskType ? 1 : 0.5
            
            const score = (sizeSimilarity + dimSimilarity + typeSimilarity) / 3
            return {record, score}
        })
        
        scores.sort((a, b) => b.score - a.score)
        return scores.slice(0, k).map(s => s.record)
    }

    getAverageScore(type) {
        const tasks = this.data.filter(t => t.taskType === type)
        if (tasks.length === 0) return 0.5
        const sum = tasks.reduce((total, t) => total + t.normalizedScore, 0)
        return sum / tasks.length
    }

    getBestParams(type) {
        const tasks = this.data.filter(t => t.taskType === type)
        if (tasks.length === 0) return null
        tasks.sort((a, b) => b.normalizedScore - a.normalizedScore)
        return tasks[0].params
    }
}

// ==================== META CONTROLLER ====================
class MetaController {
    constructor(memory) {
        this.memory = memory
        this.weights = {
            clustering: 1.0,
            classification: 1.0
        }
        this.history = []
    }

    analyze(data, labels = null) {
        const n = data.length
        const d = data[0].length
        const uniqueLabels = labels ? [...new Set(labels)].length : 0
        
        // Base scores
        let clusteringScore = 0.5
        let classificationScore = 0.5
        
        // Análise básica dos dados
        if (uniqueLabels > 1 && uniqueLabels < 10) {
            classificationScore = 0.7
        }
        if (d > 1 && n > 50) {
            clusteringScore = 0.7
        }
        
        // Aprendizado da memória
        const similar = this.memory.findSimilar({size: n, dimensions: d, taskType: 'any'})
        if (similar.length > 0) {
            const clusteringMem = this.memory.getAverageScore('clustering')
            const classificationMem = this.memory.getAverageScore('classification')
            
            clusteringScore = clusteringScore * 0.4 + clusteringMem * 0.6
            classificationScore = classificationScore * 0.4 + classificationMem * 0.6
        }
        
        // Aplicar pesos
        clusteringScore *= this.weights.clustering
        classificationScore *= this.weights.classification
        
        return {
            clusteringScore: Math.min(1.0, clusteringScore),
            classificationScore: Math.min(1.0, classificationScore),
            dataStats: {n, d, uniqueLabels},
            similarTasks: similar.length
        }
    }

    decide(analysis) {
        const threshold = 1.2
        
        if (analysis.classificationScore > analysis.clusteringScore * threshold) {
            return {
                type: 'classification',
                confidence: analysis.classificationScore,
                params: {maxDepth: 10, minSamplesSplit: 2}
            }
        } else {
            const k = Math.max(2, Math.min(8, Math.floor(Math.sqrt(analysis.dataStats.n / 10))))
            return {
                type: 'clustering',
                confidence: analysis.clusteringScore,
                params: {k}
            }
        }
    }

    learn(result) {
        const adjustment = 0.05 * (result.score - 0.5)
        
        if (result.taskType === 'clustering') {
            this.weights.clustering += adjustment
        } else {
            this.weights.classification += adjustment
        }
        
        // Limitar pesos
        this.weights.clustering = Math.max(0.1, Math.min(3.0, this.weights.clustering))
        this.weights.classification = Math.max(0.1, Math.min(3.0, this.weights.classification))
        
        this.history.push({
            iteration: this.history.length + 1,
            weights: {...this.weights},
            result: result.score,
            taskType: result.taskType
        })
    }
}

// ==================== GENETIC OPTIMIZER ====================
class GeneticOptimizer {
    constructor(popSize = 30, eliteSize = 3, mutationRate = 0.1, seed = 42) {
        this.popSize = popSize
        this.eliteSize = eliteSize
        this.mutationRate = mutationRate
        this.seed = seed
        this.rng = this._createRNG(seed)
    }

    _createRNG(seed) {
        let state = seed
        return () => {
            state = (state * 9301 + 49297) % 233280
            return state / 233280
        }
    }

    optimize(params, scoreFunc, generations = 8) {
        let population = []
        
        // População inicial
        for (let i = 0; i < this.popSize; i++) {
            const individual = {}
            for (const [key, spec] of Object.entries(params)) {
                if (spec.type === 'int') {
                    individual[key] = Math.floor(spec.min + this.rng() * (spec.max - spec.min))
                } else {
                    individual[key] = spec.min + this.rng() * (spec.max - spec.min)
                }
            }
            population.push(individual)
        }
        
        let best = null
        let bestScore = -Infinity
        
        for (let gen = 0; gen < generations; gen++) {
            // Avaliar
            const scores = population.map(ind => scoreFunc(ind))
            const scored = population.map((ind, i) => ({ind, score: scores[i]}))
            scored.sort((a, b) => b.score - a.score)
            
            if (scored[0].score > bestScore) {
                bestScore = scored[0].score
                best = {...scored[0].ind}
            }
            
            // Nova população (elitismo + crossover + mutação)
            const newPop = scored.slice(0, this.eliteSize).map(item => item.ind)
            
            while (newPop.length < this.popSize) {
                // Selecionar pais
                const p1 = scored[Math.floor(this.rng() * this.eliteSize * 2)].ind
                const p2 = scored[Math.floor(this.rng() * this.eliteSize * 2)].ind
                
                // Crossover
                const child = {}
                for (const key in p1) {
                    child[key] = this.rng() < 0.5 ? p1[key] : p2[key]
                    
                    // Mutação
                    if (this.rng() < this.mutationRate) {
                        const spec = params[key]
                        if (spec.type === 'int') {
                            child[key] = Math.floor(spec.min + this.rng() * (spec.max - spec.min))
                        } else {
                            child[key] = spec.min + this.rng() * (spec.max - spec.min)
                        }
                    }
                }
                
                newPop.push(child)
            }
            
            population = newPop
        }
        
        return best
    }
}

// ==================== TRAINER ====================
class Trainer {
    constructor(seed = 42) {
        this.seed = seed
        this.rng = this._createRNG(seed)
        this.history = []
    }

    _createRNG(seed) {
        let state = seed
        return () => {
            state = (state * 9301 + 49297) % 233280
            return state / 233280
        }
    }

    split(X, y, testSize = 0.2) {
        const n = X.length
        const indices = Array.from({length: n}, (_, i) => i)
        
        // Shuffle
        for (let i = n - 1; i > 0; i--) {
            const j = Math.floor(this.rng() * (i + 1))
            ;[indices[i], indices[j]] = [indices[j], indices[i]]
        }
        
        const testCount = Math.floor(n * testSize)
        const testIdx = indices.slice(0, testCount)
        const trainIdx = indices.slice(testCount)
        
        return {
            X_train: trainIdx.map(i => X[i]),
            X_test: testIdx.map(i => X[i]),
            y_train: trainIdx.map(i => y[i]),
            y_test: testIdx.map(i => y[i])
        }
    }

    train(model, X, y, validation = true) {
        if (validation) {
            const split = this.split(X, y, 0.2)
            model.fit(split.X_train, split.y_train)
            
            let trainScore, testScore
            
            if (model instanceof KMeans || model instanceof DBSCAN) {
                trainScore = model.score()
                testScore = model.score()
            } else {
                trainScore = model.score(split.X_train, split.y_train)
                testScore = model.score(split.X_test, split.y_test)
            }
            
            this.history.push({
                model: model.constructor.name,
                trainScore,
                testScore,
                timestamp: Date.now()
            })
            
            return {trainScore, testScore}
        } else {
            model.fit(X, y)
            const score = model.score ? model.score() : 0.5
            return {trainScore: score, testScore: score}
        }
    }
}

// ==================== AI ENGINE ====================
class AIEngine {
    constructor(config = {}) {
        this.seed = config.seed || 42
        this.memory = new Memory(config.maxMemory || 1000)
        this.controller = new MetaController(this.memory)
        this.optimizer = new GeneticOptimizer(30, 3, 0.1, this.seed)
        this.trainer = new Trainer(this.seed)
        this.metrics = Metrics
        this.currentModel = null
        this.iterations = 0
        this.history = []
        
        // Modelos disponíveis
        this.models = {
            KMeans,
            DBSCAN,
            DecisionTree,
            RandomForest
        }
    }

    solve(data, labels = null) {
        this.iterations++
        
        // Análise e decisão
        const analysis = this.controller.analyze(data, labels)
        const decision = this.controller.decide(analysis)
        
        let model, params, score
        
        if (decision.type === 'classification' && labels) {
            // Otimizar Decision Tree
            const bestParams = this.optimizer.optimize(
                {
                    maxDepth: {min: 2, max: 15, type: 'int'},
                    minSamplesSplit: {min: 2, max: 10, type: 'int'}
                },
                (p) => {
                    const split = this.trainer.split(data, labels, 0.3)
                    const tree = new DecisionTree(
                        Math.round(p.maxDepth),
                        Math.round(p.minSamplesSplit),
                        1,
                        this.seed + this.iterations
                    )
                    tree.fit(split.X_train, split.y_train)
                    return tree.score(split.X_test, split.y_test)
                },
                6
            )
            
            model = new DecisionTree(
                Math.round(bestParams.maxDepth),
                Math.round(bestParams.minSamplesSplit),
                1,
                this.seed + this.iterations
            )
            
            const result = this.trainer.train(model, data, labels)
            score = result.testScore
            params = bestParams
            
        } else {
            // Otimizar KMeans
            const bestParams = this.optimizer.optimize(
                {k: {min: 2, max: 10, type: 'int'}},
                (p) => {
                    const k = Math.round(p.k)
                    const km = new KMeans(k)
                    
                    // Usar 70% dos dados para avaliação
                    const n = data.length
                    const sampleSize = Math.floor(n * 0.7)
                    const indices = Array.from({length: n}, (_, i) => i)
                    for (let i = n - 1; i > 0; i--) {
                        const j = Math.floor(Math.random() * (i + 1))
                        ;[indices[i], indices[j]] = [indices[j], indices[i]]
                    }
                    const sample = indices.slice(0, sampleSize).map(i => data[i])
                    
                    km.fit(sample)
                    
                    // Silhouette score como métrica
                    const preds = km.predict(sample)
                    return this.metrics.silhouetteScore(sample, preds)
                },
                6
            )
            
            model = new KMeans(Math.round(bestParams.k))
            model.fit(data)
            
            // Score normalizado
            const preds = model.predict(data)
            score = this.metrics.silhouetteScore(data, preds) || model.score()
            params = bestParams
        }
        
        this.currentModel = model
        
        // Salvar na memória
        this.memory.push({
            taskType: decision.type,
            size: data.length,
            dimensions: data[0].length,
            normalizedScore: score,
            params,
            iteration: this.iterations,
            timestamp: Date.now()
        })
        
        // Aprendizado do controller
        this.controller.learn({
            taskType: decision.type,
            score,
            params
        })
        
        // Histórico
        const solution = {
            model,
            decision,
            score,
            params,
            analysis,
            iteration: this.iterations
        }
        
        this.history.push(solution)
        
        return solution
    }

    predict(data) {
        if (!this.currentModel) throw new Error('No model trained')
        return this.currentModel.predict(data)
    }

    evaluate(data, labels = null) {
        if (!this.currentModel) return 0
        
        if (this.currentModel instanceof KMeans || this.currentModel instanceof DBSCAN) {
            const preds = this.currentModel.predict(data)
            return labels ? 
                this.metrics.adjustedRandScore(labels, preds) :
                this.metrics.silhouetteScore(data, preds)
        }
        
        return this.currentModel.score(data, labels)
    }

    getStats() {
        const clusterTasks = this.memory.data.filter(t => t.taskType === 'clustering')
        const classTasks = this.memory.data.filter(t => t.taskType === 'classification')
        
        return {
            iterations: this.iterations,
            memorySize: this.memory.size(),
            currentModel: this.currentModel?.constructor.name,
            performance: {
                clustering: {
                    tasks: clusterTasks.length,
                    avgScore: clusterTasks.length ? 
                        clusterTasks.reduce((s, t) => s + t.normalizedScore, 0) / clusterTasks.length : 0
                },
                classification: {
                    tasks: classTasks.length,
                    avgScore: classTasks.length ? 
                        classTasks.reduce((s, t) => s + t.normalizedScore, 0) / classTasks.length : 0
                }
            },
            controller: {
                weights: this.controller.weights,
                historyLength: this.controller.history.length
            }
        }
    }

    clear() {
        this.memory.clear()
        this.history = []
        this.iterations = 0
        this.currentModel = null
        this.controller.history = []
    }
}

// ==================== MAIN LIBRARY ====================
const ML = {
    // Core
    Value,
    Tensor,
    
    // Data
    Scaler,
    
    // Models (Classical ML)
    KMeans,
    DBSCAN,
    DecisionTree,
    RandomForest,
    
    // Metrics
    Metrics,
    
    // Meta Learning
    MetaController,
    GeneticOptimizer,
    Trainer,
    Memory,
    
    // Main Engine
    AIEngine,
    
    // Experimental (DL)
    experimental: {
        NeuralNetwork: Experimental.NeuralNetwork,
        LinearLayer: Experimental.LinearLayer
    },
    
    // High-level API
    autoML: (data, labels = null, config = {}) => {
        const engine = new AIEngine(config)
        return engine.solve(data, labels)
    },
    
    cluster: (data, k = null, algorithm = 'kmeans') => {
        let model
        if (algorithm === 'kmeans') {
            model = k ? new KMeans(k) : new KMeans(3)
        } else {
            model = new DBSCAN()
        }
        
        model.fit(data)
        
        return {
            model,
            labels: model.labels,
            score: model.score(),
            stats: model.getClusterStats ? model.getClusterStats() : null
        }
    },
    
    classify: (X, y, options = {}) => {
        const model = options.ensemble ? 
            new RandomForest(
                options.nEstimators || 10,
                options.maxDepth || 10,
                options.minSamplesSplit || 2,
                options.seed || 42
            ) :
            new DecisionTree(
                options.maxDepth || 10,
                options.minSamplesSplit || 2,
                options.minSamplesLeaf || 1,
                options.seed || 42
            )
        
        const trainer = new Trainer(options.seed || 42)
        const result = trainer.train(model, X, y)
        
        return {
            model,
            score: result.testScore,
            history: trainer.history
        }
    },
    
    createEngine: (config = {}) => {
        return new AIEngine(config)
    },
    
    version: '3.0.0',
    
    // Quick test
    test: () => {
        console.log('=== ML Engine v3.0 Test ===')
        
        // Dados de teste
        const data = [
            [1, 2], [1, 4], [1, 0],
            [4, 2], [4, 4], [4, 0],
            [8, 2], [8, 4], [8, 0]
        ]
        const labels = [0, 0, 0, 1, 1, 1, 2, 2, 2]
        
        try {
            // Test clustering
            const clusterResult = ML.cluster(data, 3)
            console.log('✓ Clustering:', {
                score: clusterResult.score.toFixed(3),
                clusters: new Set(clusterResult.labels).size
            })
            
            // Test classification
            const classifyResult = ML.classify(data, labels, {maxDepth: 5})
            console.log('✓ Classification:', {
                score: classifyResult.score.toFixed(3),
                model: classifyResult.model.constructor.name
            })
            
            // Test AutoML
            const engine = ML.createEngine()
            const autoResult = engine.solve(data, labels)
            console.log('✓ AutoML:', {
                decision: autoResult.decision.type,
                confidence: autoResult.decision.confidence.toFixed(3),
                score: autoResult.score.toFixed(3),
                model: autoResult.model.constructor.name
            })
            
            // Test metrics
            const preds = engine.predict(data)
            const accuracy = ML.Metrics.accuracy(labels, preds)
            console.log('✓ Metrics:', {
                accuracy: accuracy.toFixed(3)
            })
            
            console.log('✓ Engine Stats:', engine.getStats())
            
            return {
                success: true,
                clustering: clusterResult,
                classification: classifyResult,
                autoML: autoResult,
                engine
            }
            
        } catch (error) {
            console.error('✗ Test failed:', error.message)
            return {success: false, error: error.message}
        }
    }
}

// Export
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ML
}
if (typeof window !== 'undefined') {
    window.ML = ML
    console.log('✅ ML Engine v3.0 loaded successfully')
    console.log('🔧 Features: Classical ML + AutoML + Meta-Learning')
    console.log('📊 Try: ML.test() for a quick demonstration')
    console.log('🚀 Ready for production use')
}