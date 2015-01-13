
module Hans.Device.PFq (pfqOpen, pfqSend, pfqReceiveLoop) where

import Prelude              -- (String, IO, Bool(..), const, (.))
import Hans.Layer.Ethernet  (EthernetHandle, queueEthernet)
import Control.Monad        (void)
import Data.ByteString.Lazy (ByteString, toChunks)
import qualified Data.ByteString.Internal as B

import qualified Network.PFq as  PFq
import Network.PFq (PFqTag)

import Foreign.ForeignPtr (ForeignPtr, withForeignPtr)

-- import Network.Pcap         (PcapHandle, openLive, loopBS, sendPacketBS)

-- | Open device with pcap, will give info about the state,
--   Unless the device is up it will throw errors later
--   Be sure to use fesh mac, otherwise all might fail.

type PFQHandle = ForeignPtr PFqTag

pfqOpen :: String -> IO PFQHandle
pfqOpen s = openLive s

openLive s = do
  dev <- PFq.open 1514 1
  withForeignPtr dev $ \ph -> do
           PFq.setPromisc ph s True
           PFq.bind       ph s 0
  -- egressBind ph s 0
  return dev

-- | send to deviece 
pfqSend :: PFQHandle -> ByteString -> IO ()
pfqSend dev bs = withForeignPtr dev $ \ph ->  mapM_ (\p -> PFq.send ph p) $ toChunks bs

-- | receive from it
pfqReceiveLoop :: PFQHandle -> EthernetHandle -> IO ()
pfqReceiveLoop dev eh = withForeignPtr dev $ \ph ->  PFq.dispatch ph (wrapBS ( const . queueEthernet $ eh)) (-1)

wrapBS :: CallbackBS -> PFq.Callback
wrapBS f hdr ptr = do
  let len = PFq.hLen hdr
  bs <- B.create (fromIntegral len) $ \p -> B.memcpy p ptr (fromIntegral len)
  f hdr bs

type CallbackBS = PFq.PktHdr -> B.ByteString -> IO ()