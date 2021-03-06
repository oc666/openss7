/*
 @(#) src/java/javax/media/mscontrol/mixer/MediaMixer.java <p>
 
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

// vim: sw=4 et tw=72 com=srO\:/**,mb\:*,ex\:*/,srO\:/*,mb\:*,ex\:*/,b\:TRANS,\://,b\:#,\:%,\:XCOMM,n\:>,fb\:-
/*

     _________________________________________________________________

   Overview  Package   Class  Use  Tree  Deprecated  Index  Help
    PREV CLASS   NEXT CLASS FRAMES    NO FRAMES     All Classes
   SUMMARY: NESTED | FIELD | CONSTR | METHOD
   DETAIL: FIELD | CONSTR | METHOD
     _________________________________________________________________

javax.media.mscontrol.mixer
Interface MediaMixer

   All Superinterfaces:
          Joinable, JoinableContainer, MediaEventNotifier<MixerEvent>,
          MediaObject, ResourceContainer<MixerConfig>,
          java.io.Serializable, StatusEventNotifier
     _________________________________________________________________

public interface MediaMixer

   extends JoinableContainer, ResourceContainer<MixerConfig>,
          MediaEventNotifier<MixerEvent>

   This class is required when the application needs to mix (or add, or
   sum) multiple media streams into a single one. Other Joinable media
   objects, like MediaGroups and NetworkConnections, can be
   joined/unjoined to a MediaMixer. The MediaMixer computes the sum of
   all ingressing streams, and sends it out to every joined object.
   On the audio stream, the contribution of a given object is actually
   not re-sent to this particular object (this would add a disturbing
   echo).
   A MediaMixer is the base for a conference service. Its usage extends
   to many other cases, including extended bridge, coaching, background
   music, etc...
   A MediaMixer can send events to the application.
     _________________________________________________________________

   Nested Class Summary



   Nested classes/interfaces inherited from interface
   javax.media.mscontrol.Joinable
   Joinable.Direction



   Field Summary



   Fields inherited from interface javax.media.mscontrol.MediaObject
   a_MediaObjectId



   Method Summary
    MixerAdapter
   createMixerAdapter(ConfigSymbol<MixerAdapterConfig> aPredefinedConfig)
             Create a instance of MixerAdapter, attached to this
   MediaMixer.
    MixerAdapter createMixerAdapter(MixerAdapterConfig aConfig,
   java.lang.String aContainerId)

    MixerAdapter createMixerAdapter(Parameters params)
             Create a MixerAdapter, providing a set of discrete
   attributes
   Example:
   Create a MixerAdapter with an Id of "chairmanMA".



   Methods inherited from interface
   javax.media.mscontrol.JoinableContainer
   getJoinableStream, getJoinableStreams



   Methods inherited from interface javax.media.mscontrol.Joinable
   getJoinees, getJoinees, join, joinInitiate, unjoin, unjoinInitiate



   Methods inherited from interface
   javax.media.mscontrol.StatusEventNotifier
   addListener, getMediaSession, removeListener



   Methods inherited from interface
   javax.media.mscontrol.resource.ResourceContainer
   confirm, getConfig, getResource, triggerRTC



   Methods inherited from interface javax.media.mscontrol.MediaObject
   getParameters, getURI, release, setParameters



   Methods inherited from interface
   javax.media.mscontrol.resource.MediaEventNotifier
   addListener, getMediaSession, removeListener



   Method Detail

  createMixerAdapter

MixerAdapter createMixerAdapter(ConfigSymbol<MixerAdapterConfig> aPredefinedCon
fig)
                                throws MscontrolException

          Create a instance of MixerAdapter, attached to this MediaMixer.

          MixerAdapters are attached to a mixer, consequently they are
          automatically released when the mixer is released.

        Parameters:
                aPredefinedConfig - a Symbol identifying a predefined
                configuration

        Throws:
                MscontrolException

        See Also:
                createMixerAdapter(Parameters),
                createMixerAdapter(MixerAdapterConfig, java.lang.String)
     _________________________________________________________________

  createMixerAdapter

MixerAdapter createMixerAdapter(Parameters params)
                                throws MscontrolException

          Create a MixerAdapter, providing a set of discrete attributes
          Example:
          Create a MixerAdapter with an Id of "chairmanMA". The other
          characteristics are unspecified and will take the
          implementation default values.

 Parameters attribs = myMsFactory.createParameters();
 attribs.put(ResourceContainer.a_MediaObjectId, "chairmanMA");
 MixerAdapter chairmanAdapter = myMixer.createMixerAdapter(attribs);


        Parameters:
                params - a set of parameters defining the resources
                required in the MixerAdapter

        Throws:
                MscontrolException

        See Also:
                createMixerAdapter(ConfigSymbol),
                createMixerAdapter(MixerAdapterConfig, java.lang.String)
     _________________________________________________________________

  createMixerAdapter

MixerAdapter createMixerAdapter(MixerAdapterConfig aConfig,
                                java.lang.String aContainerId)
                                throws MscontrolException

        Parameters:
                aConfig - an instance of MixerAdapterConfig. See
                MediaSessionFactory.getMediaConfig(ConfigSymbol) or
                MediaSessionFactory.getMediaConfig(Class, java.io.Reader)
                to create one.
                aContainerId - An application-provided Id, to replace the
                system-generated one

        Throws:
                MscontrolException

        See Also:
                createMixerAdapter(Parameters),
                createMixerAdapter(ConfigSymbol)
     _________________________________________________________________

   Overview  Package   Class  Use  Tree  Deprecated  Index  Help
    PREV CLASS   NEXT CLASS FRAMES    NO FRAMES     All Classes
   SUMMARY: NESTED | FIELD | CONSTR | METHOD
   DETAIL: FIELD | CONSTR | METHOD
     _________________________________________________________________

   Copyright (C) 2007-2008 Oracle and/or its affiliates. (C) Copyright
   2007-2008 Hewlett-Packard Development Company, L.P. All rights
   reserved. Use is subject to license terms.
*/
package javax.jain.media.mscontrol.mixer;
