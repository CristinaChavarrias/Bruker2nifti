function [path_out fname]=create_nifti_vol(Img,path,pars)

% FUNCTION create_nifti_vol.m
% Converts Vol to Nifti format with the help of all the image parameters
% (ori=orientation, r_out=readout, idist=scanner isodist, m_or=orientation
% matrix, dims= dimensions, FOV=field of view, resol=resolution,
% offset=scanner offset, tp= data type)

    ori     =   pars.orient;
    orient  =   pars.m_or;
    dims    =   pars.dims;
    resol   =   pars.resol;   %in mm
    tp      =   pars.tp;
    pos0    =   pars.pos0;
    vect    =   pars.vect;



    %datatype__________________________________________________________________
    prec = {'uint8','int16','int32','float32','float64','int8','uint16','uint32'};
    types   = [    2      4      8   16   64   256    512    768];
    dt=0;
    for j=1:size(prec,2)
      if strcmp(tp,prec(1,j)) dt=types(j); end 
    end

    dims        =   dims(vect);
    resol       =   resol(vect);

    
    %MATRIX________________________________________________________________
    mat             =  [orient*diag(resol) pos0 ; 0 0 0 1];

    if strcmp(ori,'axial') 
        mat             =   spm_matrix([0 0 0 0 pi pi 1 1 1])*mat;
    elseif strcmp(ori,'sagittal') 
        mat             =   spm_matrix([0 0 0 0 0 pi 1 1 1])*mat;
    else
        error('Only axial and sagittal for PVM_SPackArrSliceOrient considered.')
    end

    
    % Write
    [path,fname,ext]=fileparts(path);
    path_out=[path filesep fname '.nii']; 
    Vol = struct('fname',path_out,'dim',double(dims'),'mat',mat,'pinfo',[1 0 0]','descrip','fmRat image','dt',[dt 0]);
    spm_write_vol(Vol,Img);
    
end