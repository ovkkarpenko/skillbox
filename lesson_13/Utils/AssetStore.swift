//
//  AssetStore.swift
//  lesson_13
//
//  Created by Oleksandr Karpenko on 22.09.2020.
//

import Foundation
import AVFoundation

class AssetStore {
    
    var videos: [AVAsset] = []
    var audio: [AVAsset] = []
    
    func addVideo(_ video: AVAsset) {
        self.videos.append(video)
    }
    
    func addAudio(_ audio: AVAsset) {
        self.audio.append(audio)
    }
    
    static func asset(_ resource: String, type: String) -> AVAsset {
        guard let path = Bundle.main.path(forResource: resource, ofType: type) else { fatalError() }
        let url = URL(fileURLWithPath: path)
        return AVAsset(url: url)
    }
    
    static func test() -> AssetStore {
        let store = AssetStore()
        store.addVideo(asset("1", type: "mov"))
        store.addVideo(asset("2", type: "mov"))
        store.addVideo(asset("3", type: "mov"))
        store.addAudio(asset("4", type: "mp3"))
        store.addAudio(asset("5", type: "mp3"))
        
        return store
    }
    
    func compose() -> (AVAsset, AVMutableVideoComposition) {
        let composition = AVMutableComposition()
        
        guard let videoTrack1 = composition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)),
              let videoTrack2 = composition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
              //let audioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
        else {
            fatalError()
        }
        
        func insertVideo(track: AVMutableCompositionTrack, asset: AVAsset, at: CMTime) {
            try? track.insertTimeRange(
                CMTimeRange(start: CMTime.zero, duration: asset.duration),
                of: asset.tracks(withMediaType: .video)[0],
                at: at)
        }
        
        func insertAudio(track: AVMutableCompositionTrack, asset: AVAsset, at: CMTime) {
            try? track.insertTimeRange(
                CMTimeRange(start: CMTime.zero, duration: asset.duration),
                of: asset.tracks(withMediaType: .audio)[0],
                at: at)
        }
        
        let transitionDuration = CMTime(seconds: 1.0, preferredTimescale: 600)
        
        let video1 = videos[0]
        let video2 = videos[1]
        let video3 = videos[2]
        let audio1 = audio[0]
        let audio2 = audio[1]
        
        insertVideo(track: videoTrack1, asset: video1, at: CMTime.zero)
        insertVideo(track: videoTrack2, asset: video2, at: video1.duration - transitionDuration)
        
//        insertAudio(track: audioTrack, asset: audio1, at: CMTime.zero)
        
//        try? videoTrack1.insertTimeRange(
//            CMTimeRange(start: CMTime.zero, duration: video1.duration),
//            of: video1.tracks(withMediaType: .video)[0],
//            at: CMTime.zero)
//
//        try? videoTrack2.insertTimeRange(
//            CMTimeRange(start: CMTime.zero, duration: video2.duration),
//            of: video2.tracks(withMediaType: .video)[0],
//            at: video1.duration - transitionDuration)
        
//        try? audioTrack.insertTimeRange(
//            CMTimeRange(start: CMTime.zero, duration: video1.duration + video2.duration),
//            of: audio1.tracks(withMediaType: .audio)[0],
//            at: CMTime.zero)
        
        let passThroughInstruction1 = AVMutableVideoCompositionInstruction()
        passThroughInstruction1.timeRange = CMTimeRange(start: CMTime.zero, duration: video1.duration - transitionDuration)
        
        let passThroughLayerInstruction1 = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack1)
        passThroughLayerInstruction1.setTransform(videoTrack1.preferredTransform, at: CMTime.zero)
        passThroughInstruction1.layerInstructions = [passThroughLayerInstruction1]
        
        let passThroughInstruction2 = AVMutableVideoCompositionInstruction()
        passThroughInstruction2.timeRange = CMTimeRange(start: video1.duration, duration: video2.duration - transitionDuration)
        
        let passThroughLayerInstruction2 = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack2)
        passThroughLayerInstruction2.setTransform(videoTrack2.preferredTransform, at: CMTime.zero)
        passThroughInstruction2.layerInstructions = [passThroughLayerInstruction2]
        
        let transitionTimeRange = CMTimeRange(start: video1.duration - transitionDuration, duration: transitionDuration)
        
        let videoComposition = AVMutableVideoComposition(propertiesOf: composition)
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = transitionTimeRange
        
        let fadeOutInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack1)
        let fadeInInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack2)
        
        fadeOutInstruction.setTransform(video1.preferredTransform, at: CMTime.zero)
        fadeOutInstruction.setOpacityRamp(fromStartOpacity: 1, toEndOpacity: 0, timeRange: transitionTimeRange)
        
        fadeInInstruction.setOpacityRamp(fromStartOpacity: 0, toEndOpacity: 1, timeRange: transitionTimeRange)
        
        instruction.layerInstructions = [fadeOutInstruction, fadeInInstruction]
        videoComposition.instructions = [passThroughInstruction1, instruction, passThroughInstruction2]
        
        return (composition, videoComposition)
    }
    
    func export(asset: AVAsset, completion: @escaping (Bool) -> Void) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError() }
        
        let url = documentDirectory.appendingPathComponent("mergedVideo.mov")
        print(url)
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetLowQuality) else { fatalError() }
        exporter.outputURL = url
        exporter.outputFileType = .mov
        
        exporter.exportAsynchronously {
            DispatchQueue.main.async {
                completion(exporter.status == .completed)
            }
        }
        
    }
    
}
