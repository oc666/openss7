/*
 @(#) src/java/javax/jain/ss7/inap/operation/OriginationAttemptAuthorized.java <p>
 
 Copyright &copy; 2008-2015  Monavacon Limited <a href="http://www.monavacon.com/">&lt;http://www.monavacon.com/&gt;</a>. <br>
 Copyright &copy; 2001-2008  OpenSS7 Corporation <a href="http://www.openss7.com/">&lt;http://www.openss7.com/&gt;</a>. <br>
 Copyright &copy; 1997-2001  Brian F. G. Bidulock <a href="mailto:bidulock@openss7.org">&lt;bidulock@openss7.org&gt;</a>. <p>
 
 All Rights Reserved. <p>
 
 This program is free software: you can redistribute it and/or modify it under
 the terms of the GNU Affero General Public License as published by the Free
 Software Foundation, version 3 of the license. <p>
 
 This program is distributed in the hope that it will be useful, but <b>WITHOUT
 ANY WARRANTY</b>; without even the implied warranty of <b>MERCHANTABILITY</b>
 or <b>FITNESS FOR A PARTICULAR PURPOSE</b>.  See the GNU Affero General Public
 License for more details. <p>
 
 You should have received a copy of the GNU Affero General Public License along
 with this program.  If not, see
 <a href="http://www.gnu.org/licenses/">&lt;http://www.gnu.org/licenses/&gt</a>,
 or write to the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
 02139, USA. <p>
 
 <em>U.S. GOVERNMENT RESTRICTED RIGHTS</em>.  If you are licensing this
 Software on behalf of the U.S. Government ("Government"), the following
 provisions apply to you.  If the Software is supplied by the Department of
 Defense ("DoD"), it is classified as "Commercial Computer Software" under
 paragraph 252.227-7014 of the DoD Supplement to the Federal Acquisition
 Regulations ("DFARS") (or any successor regulations) and the Government is
 acquiring only the license rights granted herein (the license rights
 customarily provided to non-Government users).  If the Software is supplied to
 any unit or agency of the Government other than DoD, it is classified as
 "Restricted Computer Software" and the Government's rights in the Software are
 defined in paragraph 52.227-19 of the Federal Acquisition Regulations ("FAR")
 (or any successor regulations) or, in the cases of NASA, in paragraph
 18.52.227-86 of the NASA Supplement to the FAR (or any successor regulations). <p>
 
 Commercial licensing and support of this software is available from OpenSS7
 Corporation at a fee.  See
 <a href="http://www.openss7.com/">http://www.openss7.com/</a>
 */

package javax.jain.ss7.inap.operation;

import javax.jain.ss7.inap.constants.*;
import javax.jain.ss7.inap.datatype.*;
import javax.jain.ss7.inap.*;
import javax.jain.ss7.*;
import javax.jain.*;

/** This class represents the OriginationAttemptAuthorized Operation.
  * @version 1.2.2
  * @author Monavacon Limited
  */
public class OriginationAttemptAuthorized extends Operation implements java.io.Serializable {
    /** Constructor For OriginationAttemptAuthorised.  */
    public OriginationAttemptAuthorized(DPSpecificCommonParameters dPSpecificCommonParameters) {
        operationCode = OperationCode.ORIGINATION_ATTEMPT_AUTHORIZED;
        setDPSpecificCommonParameters(dPSpecificCommonParameters);
    }
    /** Gets Operation Code.  */
    public OperationCode getOperationCode() {
        return operationCode;
    }
    /** Gets Dp Specific Common Parameters.  */
    public DPSpecificCommonParameters getDPSpecificCommonParameters() {
        return dPSpecificCommonParameters;
    }
    /** Sets Dp Specific Common Parameters.  */
    public void setDPSpecificCommonParameters(DPSpecificCommonParameters dPSpecificCommonParameters) {
        this.dPSpecificCommonParameters = dPSpecificCommonParameters;
    }
    /** Gets Dialled Digits.  */ public CalledPartyNumber getDialledDigits() throws ParameterNotSetException {
        if (isDialledDigits)
            return dialledDigits;
        throw new ParameterNotSetException("Dialled Digits: not set.");
    }
    /** Sets Dialled Digits.  */
    public void setDialledDigits(CalledPartyNumber  dialledDigits) {
        this.dialledDigits = dialledDigits;
        this.isDialledDigits = true;
    }
    /** Indicates if the Dialled Digits optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isDialledDigitsPresent() {
        return isDialledDigits;
    }
    /** Gets Calling Party BusinessGroupID.  */
    public java.lang.String getCallingPartyBusinessGroupID() throws ParameterNotSetException {
        if (isCallingPartyBusinessGroupID)
            return callingPartyBusinessGroupID;
        throw new ParameterNotSetException("Calling Party BusinessGroupID: not set.");
    }
    /** Sets Calling Party Business Group ID.  */
    public void setCallingPartyBusinessGroupID(java.lang.String callingPartyBusinessGroupID) {
        this.callingPartyBusinessGroupID = callingPartyBusinessGroupID;
        this.isCallingPartyBusinessGroupID = true;
    }
    /** Indicates if the Calling Party Business Group ID optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isCallingPartyBusinessGroupIDPresent() {
        return isCallingPartyBusinessGroupID;
    }
    /** Gets Calling Party Subaddress.  */
    public CallingPartySubaddress getCallingPartySubaddress() throws ParameterNotSetException {
        if (isCallingPartySubaddress)
            return callingPartySubaddress;
        throw new ParameterNotSetException("Calling Party Subaddress: not set.");
    }
    /** Sets Calling Party Subaddress.  */
    public void setCallingPartySubaddress(CallingPartySubaddress callingPartySubaddress) {
        this.callingPartySubaddress = callingPartySubaddress;
        this.isCallingPartySubaddress = true;
    }
    /** Indicates if the Calling Party Subaddress optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isCallingPartySubaddressPresent() {
        return isCallingPartySubaddress;
    }
    /** Gets Calling Facility Group.  */
    public FacilityGroup getCallingFacilityGroup() throws ParameterNotSetException {
        if (isCallingFacilityGroup)
            return callingFacilityGroup;
        throw new ParameterNotSetException("Calling Facility Group: not set.");
    }
    /** Sets Calling Facility Group.  */
    public void setCallingFacilityGroup(FacilityGroup callingFacilityGroup) {
        this.callingFacilityGroup = callingFacilityGroup;
        this.isCallingFacilityGroup = true;
    }
    /** Indicates if the Calling Facility Group optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isCallingFacilityGroupPresent() {
        return isCallingFacilityGroup;
    }
    /** Gets Facility Group Member.  */
    public int getFacilityGroupMember() throws ParameterNotSetException {
        if (isFacilityGroupMember)
            return facilityGroupMember;
        throw new ParameterNotSetException("Facility Group Member: not set.");
    }
    /** Sets Facility Group Member.  */
    public void setFacilityGroupMember(int facilityGroupMember) {
        this.facilityGroupMember = facilityGroupMember;
        this.isFacilityGroupMember = true;
    }
    /** Indicates if the Facility Group Member optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isFacilityGroupMemberPresent() {
        return isFacilityGroupMember;
    }
    /** Gets Carrier.  */
    public Carrier getCarrier() throws ParameterNotSetException {
        if (isCarrier)
            return carrier;
        throw new ParameterNotSetException("Carrier: not set.");
    }
    /** Sets Carrier.  */
    public void setCarrier(Carrier carrier) {
        this.carrier= carrier;
        this.isCarrier = true;
    }
    /** Indicates if the Carrier optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isCarrierPresent() {
        return isCarrier;
    }
    /** Gets Travelling Class Mark.  */
    public LocationNumber getTravellingClassMark() throws ParameterNotSetException {
        if (isTravellingClassMark)
            return travellingClassMark;
        throw new ParameterNotSetException("Travelling Class Mark: not set.");
    }
    /** Sets Travelling Class Mark.  */
    public void setTravellingClassMark(LocationNumber travellingClassMark) {
        this.travellingClassMark = travellingClassMark;
        this.isTravellingClassMark = true;
    }
    /** Indicates if the Travelling Class Mark optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isTravellingClassMarkPresent() {
        return isTravellingClassMark;
    }
    /** Gets ComponentType.  This parameter indicates the type of event that
      * is reported to the SSF: <ul>
      * <li>ANY
      * <li>INVOKE
      * <li>R_RESULT
      * <li>R_ERROR
      * <li>R_REJECT
      * <li>R_RESULT_NOT_LAST </ul> */
    public ComponentType getComponentType() throws ParameterNotSetException {
        if (isComponentType)
            return componentType;
        throw new ParameterNotSetException("Component Type: not set.");
    }
    /** Sets Component Type.  */
    public void setComponentType(ComponentType componentType) {
        this.componentType = componentType;
        this.isComponentType = true;
    }
    /** Indicates if the Component Type optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isComponentTypePresent() {
        return isComponentType;
    }
    /** Gets Component Correlation ID.  */
    public  int getComponentCorrelationID() throws ParameterNotSetException {
        if (isComponentCorrelationID)
            return componentCorrelationID;
        throw new ParameterNotSetException("Component Correlation Id: not set.");
    }
    /** Sets Component Correlation ID.  */
    public void setComponentCorrelationID(int componentCorrelationID) {
       this.componentCorrelationID = componentCorrelationID;
       this.isComponentCorrelationID = true;
    }
    /** Indicates if the Component Correlation ID optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isComponentCorrelationIDPresent() {
        return isComponentCorrelationID;
    }
    /** Gets Extensions Parameter.  */
    public ExtensionField[] getExtensions() throws ParameterNotSetException {
        if (isExtensions)
            return extensions;
        throw new ParameterNotSetException("Extensions: not set.");
    }
    /** Gets a particular Extension Parameter.  */
    public ExtensionField getExtension(int index) {
        return extensions[index];
    }
    /** Sets Extensions Parameter.  */
    public void  setExtensions(ExtensionField extensions[]) {
        this.extensions = extensions;
        this.isExtensions = true;
    }
    /** Sets a particular Extensions Parameter.  */
    public void setExtension(int index, ExtensionField extension) {
        this.extensions[index] = extension;
    }
    /** Indicates if the Extensions optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isExtensionsPresent() {
        return isExtensions;
    }
    /** Gets Component.  */
    public Component getComponent() throws ParameterNotSetException {
        if (isComponent)
            return component;
        throw new ParameterNotSetException("Component: not set.");
    }
    /** Sets Component.  */
    public void setComponent(Component component) {
        this.component = component;
        this.isComponent = true;
    }
    /** Indicates if the Component optional parameter is present.
      * @return True when present, false otherwise.  */
    public boolean isComponentPresent() {
        return isComponent;
    }
    private DPSpecificCommonParameters dPSpecificCommonParameters;
    private CalledPartyNumber dialledDigits;
    private boolean isDialledDigits = false;
    private java.lang.String callingPartyBusinessGroupID;
    private boolean isCallingPartyBusinessGroupID = false;
    private CallingPartySubaddress callingPartySubaddress;
    private boolean isCallingPartySubaddress = false;
    private FacilityGroup callingFacilityGroup;
    private boolean isCallingFacilityGroup = false;
    private int facilityGroupMember;
    private boolean isFacilityGroupMember =false;
    private LocationNumber travellingClassMark;
    private boolean isTravellingClassMark = false;
    private Carrier carrier;
    private boolean isCarrier = false;
    private ComponentType componentType;
    private boolean isComponentType = false;
    private int componentCorrelationID;
    private boolean isComponentCorrelationID =false;
    private ExtensionField extensions[];
    private boolean isExtensions = false;
    private Component component;
    private boolean isComponent =false;
}

// vim: sw=4 et tw=72 com=srO\:/**,mb\:*,ex\:*/,srO\:/*,mb\:*,ex\:*/,b\:TRANS,\://,b\:#,\:%,\:XCOMM,n\:>,fb\:-
