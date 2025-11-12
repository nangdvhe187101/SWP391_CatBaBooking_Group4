/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class Features {
    private int featureId;
    private String featureName;
    private String url;

    public Features() {
    }

    public Features(int featureId, String featureName, String url) {
        this.featureId = featureId;
        this.featureName = featureName;
        this.url = url;
    }

    public int getFeatureId() {
        return featureId;
    }

    public void setFeatureId(int featureId) {
        this.featureId = featureId;
    }

    public String getFeatureName() {
        return featureName;
    }

    public void setFeatureName(String featureName) {
        this.featureName = featureName;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @Override
    public String toString() {
        return "Features{" + "featureId=" + featureId + ", featureName=" + featureName + ", url=" + url + '}';
    }

}