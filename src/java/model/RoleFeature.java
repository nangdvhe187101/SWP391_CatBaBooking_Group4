/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class RoleFeature {
    private int roleId;
    private int featureId;
    private String roleName;
    private String featureName;
    private String url;

    public RoleFeature() {
    }

    public RoleFeature(int roleId, int featureId) {
        this.roleId = roleId;
        this.featureId = featureId;
    }

    public RoleFeature(int roleId, int featureId, String roleName, String featureName, String url) {
        this.roleId = roleId;
        this.featureId = featureId;
        this.roleName = roleName;
        this.featureName = featureName;
        this.url = url;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public int getFeatureId() {
        return featureId;
    }

    public void setFeatureId(int featureId) {
        this.featureId = featureId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
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
        return "RoleFeature{" +
                "roleId=" + roleId +
                ", featureId=" + featureId +
                ", roleName='" + roleName + '\'' +
                ", featureName='" + featureName + '\'' +
                ", url='" + url + '\'' +
                '}';
    }
}
