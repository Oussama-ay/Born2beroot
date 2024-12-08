<div align="center">
   <h1 style="font-size: 3em; border-bottom: 2px solid #333; padding-bottom: 10px;">
      Born2beroot: Secure Server Setup
   </h1>
</div>

## 1. Introduction

The **Born2beroot** project is an exciting dive into system administration. Using **Debian** as the operating system, this project focuses on setting up a secure and functional server environment while exploring foundational system administration concepts.

---

## 2.A Word of Advice

If you’re new to system administration, take some time to learn its basics before setting it up. and the best thing is to start the partitions of the bonus part of this project, you’ll see the practical benefits compared to mandatory partitions.

## 3. Virtual Machine  

A **Virtual Machine (VM)** is software that simulates a physical computer. It creates a sandboxed environment, allowing you to run multiple operating systems without affecting your host system.

### How Does It Work?  
At the core of virtualization is the hypervisor, a layer of software that manages the VM’s access to your physical hardware (CPU, memory, and storage). The hypervisor ensures each VM operates independently and securely.

There are two types of hypervisors:

#### Type 1 (Bare-metal): Runs directly on hardware, often used in enterprise setups (e.g., VMware ESXi, Microsoft Hyper-V).
#### Type 2 (Hosted): Runs on top of an existing operating system, suitable for personal or development use (e.g., VirtualBox, VMware Workstation).
In this project, I used VirtualBox, a Type 2 hypervisor, to create and manage my virtual machine.

### Purpose of Using a VM  
- **Learning:** Experiment without risk to your host OS.  
- **Security:** Test configurations safely.  
- **Portability:** VMs can be easily cloned or moved between machines.  

---

## 4. Partitions  

Partitions divide a disk into sections to help organize and manage data. The key types are:  
- **Primary Partition:** Limited to 4 per disk, each holds a single filesystem.
- **Extended Partition:** A workaround to create more partitions; holds logical partitions.
- **Logical Partition:** Subdivisions inside an extended partition.    

---

## 5. Logical Volume Manager (LVM)  

**LVM** is a system for managing disk partitions more flexibly than traditional methods.  

### Why Use LVM?  
- Resize partitions without restarting.
- Combine multiple physical disks into a single logical volume.
- Create snapshots for backups or testing.

> **Pro Tip:** Learn the basics of LVM before trying to implement it. During the bonus setup, you’ll get hands-on practice and see the differences compared to basic partitions.

---

## 6. AppArmor  

**AppArmor** is a security module that restricts program access to files and resources. It uses predefined profiles to control what each program can do, enhancing the system's overall security.

---

## 7. Secure Shell (SSH)  

**SSH** is a protocol for secure remote server management.  

### Configuration Details:  
- Port: `4242`  
- Root login: Disabled to prevent unauthorized access.  

---

## 8. Uncomplicated Firewall (UFW)  

**UFW** simplifies managing firewall rules on Debian.  

### My Configuration:  
- Only port `4242` is open to ensure secure SSH access.  

---

## 9. Password Policy and Sudo Configuration  

### Password Policy  
- Passwords expire every 30 days.  
- Minimum 10 characters, including uppercase, lowercase, and numbers.  
- Warnings issued 7 days before expiration.  

### Sudo Configuration  
- Authentication limited to 3 incorrect attempts.  
- All commands logged in `/var/log/sudo/`.  
- Custom error messages for failed attempts.  

---

## 10. The `/etc` Directory  

The `/etc` directory is the heart of system configuration in Linux.  

### Config Files vs. Config.d Folders  
- **Config Files:** Contain main settings for the system.  
- **Config.d Folders:** Allow modular configuration by adding or removing files without altering the main configuration file.  

### Why Use Config.d?  
This approach keeps configurations organized and minimizes the risk of breaking the system when making changes.

---

## 11. Monitoring Script  

I created a Bash script (`monitoring.sh`) that displays system statistics every 10 minutes.  

```bash
#!/bin/bash

wall "
    #Architecture: $(uname -a)
    #CPU physical: $(cat /proc/cpuinfo | grep 'physical id' | sort -u | wc -l)
    #vCPU: $(nproc)
    #Memory Usage: $(free -m | awk '/Mem/ {printf(\"%d/%dMB (%.2f%%)\", $3, $2, ($3*100/$2))}')
    #Disk Usage: $(df -h --total | grep total | awk '{printf(\"%.1f/%dGb (%s)\", $3, $2, $5)}')
    #CPU load: $(top -bn1 | grep 'Cpu' | awk '{printf \"%.2f%%\\n\", $2 + $4}')
    #Last boot: $(uptime -s | head -c 16)
    #LVM use: $(lsblk | grep lvm | wc -l | awk '{if ($1 != 0) {printf(\"yes\");} else printf(\"no\");}')
    #Connections TCP: $(ss -t | grep ESTAB | wc -l) ESTABLISHED
    #User log: $(who | wc -l)
    #Network: IP: $(hostname -I) $(ip a | grep link/ether | awk '{printf(\"(%s)\", $2);}')
    #Sudo: $(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l | awk '{printf(\"%d cmd\\n\", $1);}')
"
```

### What Does It Show?  
- OS architecture and kernel version.  
- CPU, memory, and disk usage.  
- Network connections and users logged in.  
- Number of sudo commands executed.  


