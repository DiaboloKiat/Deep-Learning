<h1 align="center"> Single Shot MultiBox Detector </h1>
<h2 align="center"> Introduction </h2>
<h3 align="left"> Object Detection Systems 簡介 </h3>

#### 傳統方法由三個部分構成，分別為:
- **Object Localization (滑动窗口)** (Hypothesize bounding boxes), ex: [Sliding Windows](https://blog.csdn.net/JNingWei/article/details/78866850).
- **Feature Extraction (特徵提取)** (Resample pixels or features for each box), ex: SIFT (Scale Invariant Feature Transform), HOG (Histogram of Oriented Gradient).
- **Image Classification (影像分類)** (Apply a highquality classifier), ex: SVM (Support Vector Machine), Adabosst (Adaptive Boosting).

Object Detection = Object Localization + Feature Extraction + Classification

#### Deep Learning 方法
- Deep Learning 出現之後，Object Detection 有了取得重大突破。主要有個兩方向:
    - 以R-CNN為代表(基於 Region Proposal)的深度學習目標檢測算法，如: R-CNN，Fast R-CNN，Faster R-CNN。尤其是基於Faster-RCNN的檢測都在 PASCAL VOC，COCO和ILSVRC上都取不錯的成果。
    - 以YOLO為代表(基於 Regression)的深度學習目標檢測算法，如: YOLO (You Only Look Once)，SSD (Single Shot MultiBox Detector)。

<h3 align="left"> 為甚麼會有 SSD，與優點為何? </h3>

- SSD論文中提到，Faster R-CNN這一類方法雖然準確率高，但伴隨的就是計算量過大的問題。就算是在等級較較高的硬體，也很難達到 real-time檢測。通常檢測速度的度量是以FPS( Frame per Second)，每秒幾張畫面在計算，而Faster R-CNN僅能以每秒7個畫面的速度運作，而且就算有調整流程中步驟來加快檢測速度，但卻是以犧牲檢測精度方式來處理。

<h2 align="center"> SSD Model </h2>

<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/OneStage/SSD/SSD_img/SSD_Architecture.png" width="100%" height="100%">
<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/OneStage/SSD/SSD_img/VGG-16_Architecture.png" width="100%" height="100%">

### SSD有以下幾個特點
- 特徵提取網路的基礎架構是採用 VGG-16，去除了 VGG-16 的全連結層 FC8，將 FC6、FC7 轉換為卷積層。Pool 5不進行分辨率減小，在 FC6上使用擴張卷積 (dilated convolution) 彌補損失的感受野(Receptive Field)；並且增加了一些分辨率遞減的卷積層。
- SSD 摒棄了 proposal 的生成階段，使用 anchor 機制，這裡的 anchor 就是位置和大小固定的 box，可以理解成事先設置好的固定的 proposal。
- SSD 使用不同深度的卷積層預測不同大小的目標，對於小目標使用分辨率較大的較低層，即在低層特徵圖上設置較小的 anchor，高層的特徵圖上設置較大 anchor。
- 預測模塊：使用3x3的卷積對每個 anchor 的類別和位置直接進行回歸。
- SSD 使用的資料增強 (data augmentation) 對效果影響很大。

<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/OneStage/SSD/SSD_img/1.png" width="100%" height="100%">

### SSD 與 YOLO 比較
<img src="https://github.com/DiaboloKiat/Deep-Learning/blob/master/Introduction/OneStage/SSD/SSD_img/SSD_vs_YOLO.png" width="100%" height="100%">

- YOLO的特點，是將object detection視為一個single regression problem，在從影像輸入到輸出的結果預測僅靠一個CNN來實現，利用CNN來同時預測多個bounding-box並且針對每一個box來計算物體的機率，而在訓練的時候是直接拿整張圖丟到NN中來訓練。將原本分散的object detection 步驟融合成一個single neural network，透過整張影像的features來預測每一個bounding box，並且同時計算每個bounding box對於每一個class的機率。
- YOLO更詳細的介紹，請參考[(Link)](https://medium.com/@chenchoulo/yolo-%E4%BB%8B%E7%B4%B9-4307e79524fe)。

<h2 align="center"> Reference </h2>

- [SSD: Single Shot MultiBox Detector 介紹](https://medium.com/@bigwaterking01/ssd-single-shot-multibox-detector-%E4%BB%8B%E7%B4%B9-1fe95073c1a3)
- [[Deep Learning] SSD: Single Shot MultiBox Detector](https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/625669/)
- [論文閱讀](https://blog.csdn.net/u010167269/article/details/52563573)





