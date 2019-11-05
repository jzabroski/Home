# Office Set-up
1. RAM
    * WINNER: G.SKILL TridentZ Series 64GB (4 x 16GB) 288-Pin DDR4 SDRAM DDR4 3200 (PC4 25600) Intel Z370 Platform / Intel X99 Platform Desktop Memory Model F4-3200C14Q-64GTZSW [Amazon](https://www.amazon.com/G-SKILL-TridentZ-3200MHz-PC4-25600-F4-3200C14Q-64GTZ/dp/B01AQIQFUE)
       * Brand G.SKILL , Series TridentZ Series , Model F4-3200C14Q-64GTZ
       * Capacity 64GB (4 x 16GB) , Type 288-Pin DDR4 SDRAM , Speed DDR4 3200 (PC4 25600) , Cas Latency 14
       * Timing 14-14-14-34 , Voltage 1.35V ECC
       * No Buffered/Registered Unbuffered
       * Kit Dual Channel Kit Heat Spreader Yes
    * RUNNER-UP: G.SKILL TridentZ Series 64GB (4 x 16GB) 288-Pin DDR4 SDRAM DDR4 3200 (PC4 25600) Intel Z370 Platform Desktop Memory Model F4-3200C14Q-64GTZ
    * LOSER: G.SKILL TridentZ Series 64GB (4 x 16GB) 288-Pin DDR4 SDRAM DDR4 3200 (PC4 25600) Intel Z370 Platform / Intel X99 Platform Desktop Memory Model F4-3200C15Q-64GTZSW
2. SSD
    * Intel 905p Optane 960GB
    * RAID
        * ASUS HYPER M.2 X16 CARD [ASUS](https://www.asus.com/us/Motherboard-Accessories/HYPER-M-2-X16-CARD/)
3. CPU
    * Intel i9-9900k
4. Motherboard
    * [ASRock Z390 Phantom Gaming 4](https://www.asrock.com/mb/Intel/Z390%20Phantom%20Gaming%204/index.us.asp#Download)
5. Monitors
    * 2 Dell U3818DW (UltraSharp 38" Curved Monitor)
    * Loctek Monitor Mount Heavy Duty Gas Spring Swing Monitor Arm Desk Mount Stand Fits for 10"-34" Monitor Weighting 13.2-33 lbs - D7L [Amazon](https://www.amazon.com/gp/product/B01BXP9LT6/)
6. Desk
    * Autonomous AI SmartDesk 2 Business Edition - XL
7. Mouse
    * Logitech MX Master 2S
8. Keyboard
    * Microsoft Natural Ergonomic 4000

# Potential SAN / NAS Research

## Reddit Thread:

### Best Answer
"You're going to need a special backplane, [like] Super Micro's [nvme products](http://www.supermicro.com/en/products/nvme)" by [agrajag9](https://www.reddit.com/user/agrajag9/)

> Unfortunately to get more than a few of these in, you're going to need special backplanes. I know Super Micro makes some equipment for this (http://www.supermicro.com/en/products/nvme), but I don't think any of them use M.2 and I'm guessing these are all way outside your budget anyways.
> 
> The problem is that NMVe drives eat up 4x PCIe lanes. Systems with lots of lanes - like EPYC - and expanders/backplanes are all expensive.
> 
> I think you could probably make this work on a lower-end system with only a pair of M.2 sticks in a mirror or stripe, but really I would recommend reevaluating the whole idea. NVMe drives just are too expensive to waste on something like an archival NAS.


### Best Out-Side-The-Box Answer:

> From the Amazon link, a great comment found in a review about his adapter. Things to consider with the motherboard & CPU:
> 
> > This cards has a lot of variables that need to be meet before it will work.
> > 
> > 1. 16 pci express lanes is a lot. Most CPU's will not have enough for this, and two GPU's for example. As that is 48 pci lanes needed for 2 GPU's and one of these cards fully loaded. So lets say you buy a super expensive I9 Intel Processor. Well that CPU only has 44 pci lanes. Meaning at max you can only get 3 of the M.2 cards to work in this device while still having two GPU's running all 16 of there lanes.
> > 2. Mother boards are deceptive. While they may on average have 4 slots that will fit a x16 card. They do not all have 16 CPU express lanes assigned to them. Most often only the first slot (the one closest to the CPU socket), and the third slot actually have 16 lanes. The other two slots will only have 8. Even on high end boards. Meaning that only two of the M.2 cards will be recognized when plugged in there. So check your motherboard manuals first.
> > 3. Intel requires you to also buy a VROC key. This is not required on AMD. I have seen some people blame that on this card.
> > 4. Sense the speed of this card is heavily dependent on the slot you put it in, and the CPU running the system. Is why it says you can get up to 128Gbps. Realistically though... Unless you really know what you are doing you won't hit those speeds. But it will still be faster then what your used too. Most SSD's are limited by the sata cable speed, and other things. Which won't be anywhere as fast as m.2 drives raided.
> > 5. This tech is still new. So not all motherboards support it. Actually most don't. While the card itself doesn't need any drivers to run. The MB and CPU both need to support NVMe raid. Or your better off getting a single m.2 card.

Source: https://www.reddit.com/r/freenas/comments/a069cy/can_i_use_all_pcie_nvme_m2_ssd_for_a_nas/eafmmse?utm_source=share&utm_medium=web2x
