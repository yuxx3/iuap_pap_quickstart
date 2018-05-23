package com.yonyou.iuap.example.dictionary.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.apache.commons.collections.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.yonyou.iuap.example.dictionary.dao.DictionaryMapper;
import com.yonyou.iuap.example.dictionary.entity.Dictionary;
import com.yonyou.iuap.mvc.type.SearchParams;

@Service
public class DictionaryService {
	
    @Autowired
    private DictionaryMapper dictionaryMapper;
    
    /**
     * 查询组织分页数据
     * 
     * @param pageRequest
     * @param searchParams
     * @return
     */
    public Page<Dictionary> selectAllByPage(PageRequest pageRequest, SearchParams searchParams) {
        return dictionaryMapper.selectAllByPage(pageRequest, searchParams.getSearchMap()).getPage();
    }

    /**
     * 查询
     * @param keyword
     * @return
     */
    public List<Dictionary> query4Refer(String refParam){
    	Map<String,Object> params = new HashMap<String,Object>();
    	params.put("refParam", refParam);
    	return dictionaryMapper.queryList(params);
    }

    public List<Dictionary> findByCode(String code) {
        return dictionaryMapper.findByCode(code);
    }
    
    /**
     * 查询所有组织
     * 
     * @return
     */
    public List<Dictionary> selectAll() {
        return dictionaryMapper.findAll();
    }

    /**
     * 保存组织
     * 
     * @param recordList
     */
    @Transactional
    public void save(List<Dictionary> recordList) {
        List<Dictionary> addList = new ArrayList<>(recordList.size());
        List<Dictionary> updateList = new ArrayList<>(recordList.size());
        for (Dictionary er : recordList) {

            if (er.getId() == null) {
            	er.setId(UUID.randomUUID().toString());
//            	er.setDr(0);
                addList.add(er);
            } else {
                updateList.add(er);
            }
        }
        if (CollectionUtils.isNotEmpty(addList)) {
        	dictionaryMapper.batchInsert(addList);
        }
        if (CollectionUtils.isNotEmpty(updateList)) {
        	dictionaryMapper.batchUpdate(updateList);
        }
    }

    /**
     * 删除组织
     * 
     * @param list
     */
    public void batchDeleteByPrimaryKey(List<Dictionary> list) {
    	dictionaryMapper.batchDelete(list);
    }

}