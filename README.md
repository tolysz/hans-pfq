[![Build Status](https://travis-ci.org/tolysz/hans-pfq.svg?branch=master)](https://travis-ci.org/tolysz/hans-pfq)
[![Latest Version](https://img.shields.io/hackage/v/hans-pfq.svg)](https://hackage.haskell.org/package/hans-pfq)

hans-pfq
========


Network ethernet device for HaNS [hans-2.4](https://github.com/GaloisInc/HaNS), which can tap into a real ethernet interface, all using pcap library and preform raw packet reads & writes.
This is a very naïve implementation, however not much I can be squeeze from pfq.
Top run requires: root - all because we need to use PFq.

example use:

    import Hans.NetworkStack
    import Hans.Device.PFq

    main :: IO ()
    main = do
      ns  <- newNetworkStack
      -- MAC we want to have; make it unique
      let mac = Mac 1 2 3 4 5 6

      -- device we attach to
      dev <- pfqOpen "eth0" 
      addDevice ns mac (pfqSend dev) (pfqReceiveLoop dev)
      deviceUp ns mac


And we can continue using HaNS as normal.
See example/gal.hs for a working example.


Install
=======

??
It requires  `???` (as it is required by `???`) to run, So on Debian (or simmilar)_

	sudo apt-get install ???
 
