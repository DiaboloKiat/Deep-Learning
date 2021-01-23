<h1 align="center"> Single Shot MultiBox Detector </h1>

## Introduction
### Object Detection systems 簡介
#### 傳統方法由三個部分構成，分別為:
- **Object Localization** (Hypothesize bounding boxes), ex: Sliding Windows.
- **Feature Extraction** (Resample pixels or features for each box), ex: SIFT, HOG…
- **Image Classification** (Apply a highquality classifier), ex: SVM, Adabosst…

object detection = Object Localization + Feature Extraction + Classification

#### Deep Learning 方法
- Deep Learning 出現之後，object detection 有了取得重大突破。主要有個兩方向:
    - 以R-CNN為代表(基於 Region Proposal)的深度學習目標檢測算法，如: R-CNN，Fast R-CNN，Faster R-CNN。尤其是基於Faster-RCNN的檢測都在 PASCAL VOC，COCO和ILSVRC上都取不錯的成果。
    - 以YOLO為代表(基於 Regression)的深度學習目標檢測算法，如: YOLO (You Only Look Once)，SSD (Single Shot MultiBox Detector)。

### 為甚麼會有 SSD，與優點為何?
SSD論文中提到，Faster R-CNN這一類方法雖然準確率高，但伴隨的就是計算量過大的問題。就算是在等級較較高的硬體，也很難達到 real-time檢測。通常檢測速度的度量是以FPS( Frame per Second)，每秒幾張畫面在計算，而Faster R-CNN僅能以每秒7個畫面的速度運作，而且就算有調整流程中步驟來加快檢測速度，但卻是以犧牲檢測精度方式來處理。

## SSD Model
<img src="" width="100%" height="100%">
<img src="" width="100%" height="100%">

### SSD有以下幾個特點
- 特徵提取網路的基礎架構是採用 VGG-16，去除了 VGG-16 的全連結層 FC8，將 FC6、FC7 轉換為卷積層。Pool 5不進行分辨率減小，在 FC6上使用擴張卷積 (dilated convolution) 彌補損失的感受野(Receptive Field)；並且增加了一些分辨率遞減的卷積層。
- SSD 摒棄了 proposal 的生成階段，使用 anchor 機制，這裡的 anchor 就是位置和大小固定的 box，可以理解成事先設置好的固定的 proposal。
- SSD 使用不同深度的卷積層預測不同大小的目標，對於小目標使用分辨率較大的較低層，即在低層特徵圖上設置較小的 anchor，高層的特徵圖上設置較大 anchor。

<img src="" width="100%" height="100%">
- 預測模塊：使用3x3的卷積對每個 anchor 的類別和位置直接進行回歸。
- SSD 使用的資料增強 (data augmentation) 對效果影響很大。

## Reference
- [SSD: Single Shot MultiBox Detector 介紹](https://medium.com/@bigwaterking01/ssd-single-shot-multibox-detector-%E4%BB%8B%E7%B4%B9-1fe95073c1a3)
- [[Deep Learning] SSD: Single Shot MultiBox Detector](https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/625669/)
- [論文閱讀](https://blog.csdn.net/u010167269/article/details/52563573)





