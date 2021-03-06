
/*************示例应用：档案-字典（单表）***************/
DROP TABLE IF EXISTS `example_dictionary`;
CREATE TABLE example_dictionary (
  id VARCHAR(36) NOT NULL,
  code VARCHAR(50) DEFAULT NULL,
  name VARCHAR(50) DEFAULT NULL,
  sys VARCHAR(50) DEFAULT NULL,
  creator VARCHAR(50) DEFAULT NULL,
  create_time VARCHAR(50) DEFAULT NULL,
  remark VARCHAR(50) DEFAULT NULL,
  PRIMARY KEY (id)
) ;



/*************示例应用：联系人（树表）***************/
DROP TABLE IF EXISTS `example_contacts`;
CREATE TABLE example_contacts (
  id CHAR(36) NOT NULL,
  peocode VARCHAR(100) NOT NULL,
  peoname VARCHAR(50) NOT NULL,
  sex VARCHAR(50) DEFAULT NULL,
  worktel VARCHAR(100) DEFAULT NULL,
  office VARCHAR(100) DEFAULT NULL,
  tel VARCHAR(100) DEFAULT NULL,
  email VARCHAR(100) DEFAULT NULL,
  countryzone VARCHAR(36) DEFAULT NULL,
  institid CHAR(36) DEFAULT NULL,
  institname CHAR(50) DEFAULT NULL,
  ts DATE DEFAULT NULL,
  dr INT(11) DEFAULT '0',
  PRIMARY KEY (id)
);



/*************示例应用：组织机构（树表---树）***************/
DROP TABLE IF EXISTS `example_organization`;
CREATE TABLE example_organization (
  institid CHAR(36) NOT NULL,
  instit_code VARCHAR(200) NOT NULL,
  instit_name VARCHAR(200) NOT NULL,
  short_name VARCHAR(50) DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  instit_type VARCHAR(10) DEFAULT NULL,
  parent_id VARCHAR(36) DEFAULT NULL,
  creator VARCHAR(20) DEFAULT NULL,
  creationtime DATE DEFAULT NULL,
  ts DATE DEFAULT NULL,
  dr INT(11) DEFAULT '0',
  PRIMARY KEY (institid)
);



/*************示例应用：商品管理（单表+参照使用）***************/
DROP TABLE IF EXISTS `example_goods`;
CREATE TABLE example_goods (
  id varchar(64) NOT NULL COMMENT '主键ID',
  goodsCode varchar(20) NOT NULL COMMENT '商品编码',
  goodsName varchar(64) NOT NULL COMMENT '商品名称',
  model varchar(64) DEFAULT NULL COMMENT '型号',
  price decimal(10,0) DEFAULT NULL COMMENT '单价',
  currency varchar(64) DEFAULT NULL COMMENT '币种',
  manufacturer varchar(64) DEFAULT NULL COMMENT '制造商',
  remark varchar(1024) DEFAULT NULL COMMENT '备注',
  version int(11) DEFAULT '0' COMMENT '版本',
  createTime timestamp NULL DEFAULT NULL COMMENT '创建人',
  createUser varchar(64) DEFAULT NULL COMMENT '创建时间',
  lastModified timestamp NULL DEFAULT NULL COMMENT '修改人',
  lastModifyUser varchar(64) DEFAULT NULL COMMENT '修改时间',
  ts timestamp NULL DEFAULT NULL COMMENT '数据创建时间',
  dr int(11) DEFAULT NULL COMMENT '删除标志：0-可用；1-已删除',
  tenant_id varchar(50) DEFAULT NULL,
  director varchar(50) DEFAULT NULL COMMENT '业务负责人',
  supplier varchar(100) DEFAULT NULL COMMENT '供应商',
  linkman varchar(64) DEFAULT NULL COMMENT '供应商联系人',
  linkmanMobile varchar(20) DEFAULT NULL COMMENT '联系人电话',
  supplierTel varchar(20) DEFAULT NULL COMMENT '供应商电话',
  supplierFax varchar(20) DEFAULT NULL COMMENT '供应商传真',
  supplierAddr varchar(128) DEFAULT NULL COMMENT '供应商地址',
  PRIMARY KEY (id)
);


/*************示例应用：订单管理（主子表+航编辑+行编辑参照使用）***************/
DROP TABLE IF EXISTS `example_order_bill`;
CREATE TABLE example_order_bill (
  id CHAR(36) NOT NULL COMMENT '主键ID',
  orderCode VARCHAR(50) DEFAULT NULL COMMENT '订单编号',
  orderName VARCHAR(50) DEFAULT NULL COMMENT '订单名称',
  orderDate DATETIME DEFAULT NULL COMMENT '订单日期',
  beginDate DATE DEFAULT NULL COMMENT '开始时间',
  endDate DATE DEFAULT NULL COMMENT '结束时间',
  customer VARCHAR(255) DEFAULT NULL COMMENT '订单客户',
  dept VARCHAR(36) DEFAULT NULL COMMENT '组织机构',
  busiman VARCHAR(50) DEFAULT NULL COMMENT '业务员',
  amount DECIMAL(10,0) DEFAULT NULL COMMENT '订单金额',
  currency VARCHAR(36) DEFAULT NULL COMMENT '币种',
  orderState VARCHAR(10) DEFAULT NULL COMMENT '订单状态',
  version INT(11) DEFAULT '0' COMMENT '版本号',
  createTime TIMESTAMP(6) NULL DEFAULT NULL COMMENT '创建时间',
  createUser VARCHAR(36) DEFAULT NULL COMMENT '创建人',
  lastModified TIMESTAMP(6) NULL DEFAULT NULL COMMENT '最后修改时间',
  lastModifyUser VARCHAR(36) DEFAULT NULL COMMENT '最后修改人',
  ts TIMESTAMP(6) NULL DEFAULT NULL COMMENT '数据时间',
  dr INT(11) DEFAULT '0' COMMENT '删除标志：0-未删除；1-已删除',
  PRIMARY KEY (id)
);


/*************示例应用：订单管理（子表）***************/
DROP TABLE IF EXISTS `example_order_detail`;
CREATE TABLE example_order_detail (
  id CHAR(36) NOT NULL COMMENT '订单明细ID',
  orderId CHAR(36) DEFAULT NULL COMMENT '订单ID',
  detailCode VARCHAR(50) DEFAULT NULL COMMENT '订单明细编号',
  goodsCode VARCHAR(50) DEFAULT NULL COMMENT '商品编号',
  goodsName VARCHAR(50) DEFAULT NULL COMMENT '商品名称',
  manufacturer VARCHAR(64) DEFAULT NULL COMMENT '制造商',
  price DECIMAL(10,0) DEFAULT NULL COMMENT '单价',
  total INT(4) DEFAULT NULL COMMENT '数量',
  amount DECIMAL(10,2) DEFAULT NULL COMMENT '总价',
  remark VARCHAR(1024) DEFAULT NULL,
  VERSION INT(11) DEFAULT '0' COMMENT '版本号',
  ts TIMESTAMP NULL DEFAULT NULL COMMENT '数据时间',
  dr INT(11) DEFAULT '0' COMMENT '删除标志：0-未删除；1-已删除',
  PRIMARY KEY (id)
);

/*************示例应用：附件***************/
DROP TABLE IF EXISTS `example_attachment`;
CREATE TABLE `example_attachment` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


/*************示例应用：导入、导出***************/
DROP TABLE IF EXISTS `example_template`;
CREATE TABLE `example_template` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remark` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


/*************示例应用：打印***************/
DROP TABLE IF EXISTS `example_print`;
CREATE TABLE `example_print` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `code` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remark` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;




DROP TABLE IF EXISTS `example_customer`;
CREATE TABLE `example_customer` (
  `id` varchar(36) NOT NULL,
  `customer_code` varchar(255) DEFAULT NULL COMMENT '客户编码',
  `customer_name` varchar(255) DEFAULT NULL COMMENT '客户名称',
  `province` varchar(255) DEFAULT NULL COMMENT '省份',
  `city` varchar(255) DEFAULT NULL COMMENT '城市',
  `corpSize` varchar(1) DEFAULT NULL COMMENT '企业规模',
  `status` varchar(1) DEFAULT NULL COMMENT '状态',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `example_as_val`;
create table `example_as_val`(
	`id` varchar(36) not null,
	`pid` varchar(36) not null,
	`code` varchar(36) not NULL COMMENT '编码',
	`name` varchar(255) not null COMMENT '下拉框NAME',
	`value` varchar(255) not null COMMENT '下拉框VALUE',
	`ord_index` tinyint DEFAULT NULL COMMENT '顺序',
	`lstdate` timestamp NULL DEFAULT NULL COMMENT '最后更新时间',
	`is_system` tinyint DEFAULT NULL COMMENT '是否系统预置',
	PRIMARY KEY(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `example_equip`;
CREATE TABLE `example_equip` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `org_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `org_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dept_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dept_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_user_id` varchar(36) COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `update_user_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `update_user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `create_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `version` int(11) DEFAULT NULL,
  `tenant_id` varchar(36) COLLATE utf8_unicode_ci DEFAULT 'tenant',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

DROP TABLE IF EXISTS `example_bill`;
CREATE TABLE `example_bill` (
  `id` varchar(36) COLLATE utf8_unicode_ci NOT NULL,
  `code` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '编码',
  `bill_type` varchar(255) COLLATE utf8_unicode_ci DEFAULT '' COMMENT '单据类型',
  `is_valid` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '是否有效',
  `fiscal` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '年度',
  `busi_date` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '业务时间',
  `pay_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '付款单位code',
  `pay_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '付款单位',
  `in_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '收款单位code',
  `in_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '收款单位',
  `amount` decimal(10,0) DEFAULT NULL COMMENT '金额',
  `bill_status` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '单据状态',
  `create_user_id` varchar(36) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '创建人ID',
  `create_user_name` varchar(36) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '创建人',
  `create_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_user_id` varchar(36) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '更新人ID',
  `update_user_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '更新人',
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `version` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '版本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci ROW_FORMAT=COMPACT;


/*************示例应用：流程***************/
DROP TABLE IF EXISTS `example_workorder`;
CREATE TABLE `example_workorder` (
  `id` varchar(64) NOT NULL COMMENT '主键ID',
  `code` varchar(20) NOT NULL COMMENT '工单编码',
  `name` varchar(64) NOT NULL COMMENT '工单名称',
  `type` varchar(64) DEFAULT NULL COMMENT '工单类型',
  `content` varchar(1024) DEFAULT NULL COMMENT '工单内容',
  `status` varchar(10) DEFAULT NULL COMMENT '工单状态: 0-未提交；1:已提交; 2:审批中; 3:已办结',
  `applicant` varchar(64) DEFAULT NULL COMMENT '申请人',
  `applyTime` datetime DEFAULT NULL COMMENT '申请时间',
  `finishTime` datetime DEFAULT NULL COMMENT '办结时间',
  `remark` varchar(1024) DEFAULT NULL COMMENT '备注',
  `version` int(11) DEFAULT '0' COMMENT '版本',
  `createTime` timestamp NULL DEFAULT NULL COMMENT '创建人',
  `createUser` varchar(64) DEFAULT NULL COMMENT '创建时间',
  `lastModified` timestamp NULL DEFAULT NULL COMMENT '修改人',
  `lastModifyUser` varchar(64) DEFAULT NULL COMMENT '修改时间',
  `ts` timestamp NULL DEFAULT NULL COMMENT '数据创建时间',
  `dr` int(11) DEFAULT NULL COMMENT '删除标志：0-可用；1-已删除',
  PRIMARY KEY (`id`)
);


/*************示例应用：按钮权限***************/
DROP TABLE IF EXISTS example_article;
CREATE TABLE example_article (
id varchar(255) COLLATE utf8_unicode_ci NOT NULL,
title varchar(255) NULL ,
content varchar(255) NULL ,
create_user_id varchar(36) NULL ,
create_user_name varchar(255) NULL ,
publish_user_id varchar(255) NULL ,
publish_user_name varchar(255) NULL ,
create_time DATE NULL ,
publish_time DATE NULL ,
status varchar(255) NULL,
PRIMARY KEY (`id`)
);
ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*************示例应用：通知公告***************/
DROP TABLE IF EXISTS `ex_notice`;
CREATE TABLE `ex_notice`  (
  `pk_notice` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '主键',
  `notice_code` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通知编码',
  `notice_name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通知名称',
  `dsp_dept` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `dsp_date` datetime(0) NULL DEFAULT NULL COMMENT '发文时间',
  `notice_content` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '通知内容',
  `emergency` int(11) NULL DEFAULT NULL,
  `dr` int(11) NULL DEFAULT NULL COMMENT '是否删除',
  `ts` datetime(0) NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP(0) COMMENT '更新时间',
  `version` int(11) NULL DEFAULT NULL COMMENT '版本号',
  `last_modified` datetime(0) NULL DEFAULT NULL COMMENT '最后修改时间',
  `last_modify_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最后修改人',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `process_definition_key` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '流程定义KEY',
  `process_status` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '流程状态',
  PRIMARY KEY (`pk_notice`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '通知公告' ROW_FORMAT = Compact;
