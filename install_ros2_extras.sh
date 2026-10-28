#!/usr/bin/env bash
# ============================================================
# ROS 2 Humble 补充组件安装脚本
#
# 背景：ROS 2 核心（desktop / rviz2 / gazebo / nav2 / cartographer）
#       已安装在 /opt/ros/humble，本脚本只补装缺失的部分。
#
# 用法：在**你自己的终端**（有 sudo 权限）里执行
#         bash ~/ros2_ws/install_ros2_extras.sh
#       或只装其中某一类，见下方 OPTIONAL 段落。
# ============================================================
set -e

GREEN='\033[0;32m'; NC='\033[0m'
step() { echo -e "${GREEN}==>${NC} $1"; }

step "[1/5] 更新 apt 索引"
sudo apt-get update -qq

step "[2/5] 安装常用建模工具（xacro / joint-state-publisher-gui / urdf-tutorial）"
sudo apt-get install -y \
  ros-humble-xacro \
  ros-humble-joint-state-publisher-gui \
  ros-humble-urdf-tutorial

step "[3/5] 安装 ros2_control 控制框架"
sudo apt-get install -y \
  ros-humble-ros2-control \
  ros-humble-ros2-controllers

step "[4/5] 安装源码编译所需的系统依赖（ROS 2 官方推荐）"
sudo apt-get install -y \
  python3-rosdep python3-colcon-common-extensions \
  python3-vcstool \
  libtinyxml2-dev libpugixml-dev liburdfdom-dev \
  libangles-dev libconsole-bridge-dev libassimp-dev

step "[5/5] 初始化 rosdep（若已初始化会跳过）"
if [ ! -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
  sudo rosdep init
fi
rosdep update

# ---------- OPTIONAL：按需单独安装 ----------
# 机械臂运动规划（体积约 2GB+）：
#   sudo apt-get install -y ros-humble-moveit
# 可视化调试利器：
#   sudo apt-get install -y ros-humble-plotjuggler-ros ros-humble-rqt-tf-tree
# Web 桥接（网页/上位机与 ROS 通信）：
#   sudo apt-get install -y ros-humble-rosbridge-server

echo
step "全部完成！请重新打开终端，或执行："
echo "      source ~/.bashrc"
echo "然后验证："
echo "      ros2 pkg list | grep -E 'xacro|ros2_control|controller_manager'"
echo
echo "提示：~/ros2_ws/src/joint_state_publisher 是我从源码编译的版本，"
echo "      与 apt 版本功能一致。若想统一用 apt 版，删除该目录重新 colcon build 即可。"
