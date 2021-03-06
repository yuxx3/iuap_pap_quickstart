package com.yonyou.iuap.example.reference.web.controller;

import java.util.*;

import com.yonyou.iuap.context.InvocationInfoProxy;
import com.yonyou.uap.ieop.security.entity.DataPermission;
import com.yonyou.uap.ieop.security.sdk.AuthRbacClient;
import org.apache.commons.collections.CollectionUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import com.yonyou.iuap.example.dictionary.entity.Dictionary;
import com.yonyou.iuap.example.dictionary.service.DictionaryService;
import com.yonyou.iuap.mvc.type.SearchParams;

import iuap.ref.ref.RefClientPageInfo;
import iuap.ref.sdk.refmodel.model.AbstractGridRefModel;
import iuap.ref.sdk.refmodel.vo.RefViewModelVO;

/**
 * 固定表头表格参照
 * @author Aton
 */
@RestController
@RequestMapping({"/reference/dictionary"})
public class DictionaryRefController extends AbstractGridRefModel {

	private Logger logger = LoggerFactory.getLogger(DictionaryRefController.class);

	@Override
	public RefViewModelVO getRefModelInfo(@RequestBody RefViewModelVO refViewModel) {
		RefViewModelVO retinfo = super.getRefModelInfo(refViewModel);
		refViewModel.setRefName("币种");
		refViewModel.setRootName("币种列表");
		return retinfo;
	}
	
	@Override
	public @ResponseBody
	Map<String, Object> getCommonRefData(@RequestBody RefViewModelVO refViewVo) {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		int pageNum = refViewVo.getRefClientPageInfo().getCurrPageIndex()==0 ? 1:refViewVo.getRefClientPageInfo().getCurrPageIndex();
		int pageSize = refViewVo.getRefClientPageInfo().getPageSize();
		
		PageRequest request = buildPageRequest(pageNum, pageSize, null);
		
		String searchParams = StringUtils.isEmpty(refViewVo.getContent())? null :refViewVo.getContent();
		
		Page<Dictionary> pageData = dictionaryService.selectAllByPage(request, this.buildSearchParams(searchParams));
		List<Dictionary> listData = pageData.getContent();
		if(CollectionUtils.isNotEmpty(listData)) {
			List<Map<String, String>> list = buildRtnValsOfRef(listData);
			RefClientPageInfo refPageInfo = refViewVo.getRefClientPageInfo();
			refPageInfo.setPageCount(pageData.getTotalPages());
			refPageInfo.setCurrPageIndex(pageData.getNumber());
			refPageInfo.setPageSize(pageSize);
			
			refViewVo.setRefClientPageInfo(refPageInfo);
			
			resultMap.put("dataList", list);
			resultMap.put("refViewModel", refViewVo);
		}
		return resultMap;
	}

	/**
	 * 参照数据过滤
	 * @param refViewVo
	 * @return
	 */
	@Override
	public List<Map<String, String>> filterRefJSON(@RequestBody RefViewModelVO refViewVo) {
		List<Map<String, String>> results = new ArrayList<Map<String,String>>();		
		List<Dictionary> rtnVal = this.dictionaryService.query4Refer(refViewVo.getContent());
		results = buildRtnValsOfRef(rtnVal);
		return results;
	}

	/**
	 * 获得鼠标焦点时 参照数据过滤
	 * @param refViewVo
	 * @return
	 */
	@Override
	public List<Map<String, String>> matchBlurRefJSON(@RequestBody RefViewModelVO refViewVo) {
		return filterRefJSON(refViewVo);
	}

	/**
	 * 精确匹配参照数据,在打开表单页面时会调用该方法
	 * @param refViewVo
	 * @return
	 */
	@Override
	public List<Map<String, String>> matchPKRefJSON(@RequestBody RefViewModelVO refViewVo) {
		List<Map<String, String>> results = new ArrayList<Map<String,String>>();

		try {
			List<Dictionary> rtnVal = this.dictionaryService.query4Refer(refViewVo.getContent());
			results = buildRtnValsOfRef(rtnVal);
		} catch (Exception e) {
			logger.error("服务异常：", e);
		}
		return results;
	}

	/**
	 * 构建查询条件
	 * @param searchParam
	 * @return
	 */
	private SearchParams buildSearchParams(String searchParam) {
		SearchParams params = new SearchParams();
		Map<String,Object> results = new HashMap<String,Object>();
		if(!StringUtils.isEmpty(searchParam)) {
			results.put("searchParam", searchParam);
		}
		params.setSearchMap(results);
		return params;
	}

	/**
	 * 构建分页SQL
	 * @param pageNum
	 * @param pageSize
	 * @param sortColumn
	 * @return
	 */
	private PageRequest buildPageRequest(int pageNum, int pageSize, String sortColumn) {
		Sort sort = null;
		if(StringUtils.isEmpty(sortColumn) || "auto".equalsIgnoreCase(sortColumn)) {
			sort = new Sort(Sort.Direction.ASC, new String[] {"code"});
		}else {
			sort = new Sort(Sort.Direction.ASC, new String[] {sortColumn});
		}
		return new PageRequest(pageNum-1, pageSize, sort);
	}
	
	
	private List<Map<String,String>> buildRtnValsOfRef(List<Dictionary> listDictionary){
		// 数据权限集合set
		String tenantId = InvocationInfoProxy.getTenantid();
		String sysId = InvocationInfoProxy.getSysid();
		String userId = InvocationInfoProxy.getUserid();
		List<DataPermission> dataPerms = AuthRbacClient.getInstance().queryDataPerms(tenantId, sysId, userId, "currtype");

		Set<String> set = new HashSet<String>();
		if(dataPerms != null && dataPerms.size()>0){
			for (DataPermission temp : dataPerms) {
				if(temp != null){
					set.add(temp.getResourceId());
				}
			}
		}

		List<Map<String, String>> results = new ArrayList<Map<String,String>>();
		if ((listDictionary != null) && (!listDictionary.isEmpty())) {
			for (Dictionary entity : listDictionary) {
				Map<String, String> refDataMap = new HashMap<String, String>();
				refDataMap.put("id", entity.getId());
				refDataMap.put("refname", entity.getName());
				refDataMap.put("refcode", entity.getCode());
				refDataMap.put("refpk", entity.getId());

				results.add(refDataMap);
			}
		}
		return results;
	}

	/****************************************************************/
	@Autowired
	private DictionaryService dictionaryService;
	
}