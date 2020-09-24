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
              let videoTrack2 = composition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid)),
              let videoTrack3 = composition.addMutableTrack(withMediaType: .video, preferredTrackID: Int32(kCMPersistentTrackID_Invalid))
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
        
        insertVideo(track: videoTrack1, asset: videos[0], at: CMTime.zero)
        insertVideo(track: videoTrack2, asset: videos[1], at: videos[0].duration - transitionDuration)
        insertVideo(track: videoTrack3, asset: videos[2], at: (videos[0].duration - transitionDuration) + (videos[1].duration - transitionDuration))
        
//        insertAudio(track: audioTrack, asset: audio1, at: CMTime.zero)
        
        let instruction1 = createFadeTransition(videoTrack1: videoTrack1, videoTrack2: videoTrack2, video: videos[0], start: videos[0].duration - transitionDuration, transitionDuration: transitionDuration)
        let instruction2 = createFadeTransition(videoTrack1: videoTrack2, videoTrack2: videoTrack3, video: videos[1], start: (videos[0].duration - transitionDuration) + (videos[1].duration - transitionDuration), transitionDuration: transitionDuration)
        
        let passThroughInstruction1 = createVideoInstruction(
            videoTrack: videoTrack1,
            video: videos[0],
            start: CMTime.zero,
            duration: videos[0].duration - transitionDuration)
        
        let passThroughInstruction2 = createVideoInstruction(
            videoTrack: videoTrack2,
            video: videos[1],
            start: videos[0].duration,
            duration: videos[1].duration - transitionDuration)
        
        let passThroughInstruction3 = createVideoInstruction(
            videoTrack: videoTrack3,
            video: videos[2],
            start: videos[0].duration + videos[1].duration,
            duration: videos[2].duration)
        
        let videoComposition = AVMutableVideoComposition(propertiesOf: composition)
        videoComposition.renderSize = CGSize(width: videoTrack1.naturalSize.width+1, height: videoTrack1.naturalSize.height+1)
        videoComposition.instructions = [passThroughInstruction1, instruction1, passThroughInstruction2, instruction2, passThroughInstruction3]
        
        return (composition, videoComposition)
    }
    
    func createFadeTransition(videoTrack1: AVMutableCompositionTrack, videoTrack2: AVMutableCompositionTrack, video: AVAsset, start: CMTime, transitionDuration: CMTime) -> AVMutableVideoCompositionInstruction {
        let instruction = AVMutableVideoCompositionInstruction()
        
        let transitionTimeRange = CMTimeRange(start: start, duration: transitionDuration)
        instruction.timeRange = transitionTimeRange
        
        let fadeOutInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack1)
        let fadeInInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack2)
        
        fadeOutInstruction.setTransform(video.preferredTransform, at: CMTime.zero)
        fadeOutInstruction.setOpacityRamp(fromStartOpacity: 1, toEndOpacity: 0, timeRange: transitionTimeRange)
        
        fadeInInstruction.setOpacityRamp(fromStartOpacity: 0, toEndOpacity: 1, timeRange: transitionTimeRange)
        
        instruction.layerInstructions = [fadeOutInstruction, fadeInInstruction]
        return instruction
    }
    
    func createVideoInstruction(videoTrack: AVMutableCompositionTrack, video: AVAsset, start: CMTime, duration: CMTime) -> AVMutableVideoCompositionInstruction {
        let passThroughInstruction = AVMutableVideoCompositionInstruction()
        passThroughInstruction.timeRange = CMTimeRange(start: start, duration: duration)
        
        let passThroughLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        passThroughLayerInstruction.setTransform(videoTrack.preferredTransform, at: CMTime.zero)
        passThroughInstruction.layerInstructions = [passThroughLayerInstruction]
        
        return passThroughInstruction
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
