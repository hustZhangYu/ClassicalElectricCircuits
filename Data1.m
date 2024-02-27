% ����������ڶ�ȡ��Ӧ�ľ���
% �����ȸ�������ľ��岽��
% a. һ����ѭ����ȡ���е��ļ�
% b. �����ĳһ��������ļ����������ȶ�ȡ���ĵ����к͵�����
% c. ��ȡ���ĵ����к͵����У����ַ��������֣����Ұѵ�λ�����滻
% d. �����µ�������򣬶����������

clear all;
clc;


m=10;
G=zeros(m,m);

for m1=1:m
    file_path = "100k_"+num2str(m1)+".csv";
    
    for m2=1:m
        fileID = fopen(file_path, 'r');
        
        % ��ȡ��һ��
        line_number = m2; % ���磬Ҫ��ȡ��һ�У�����ֵ��Ϊ 1

        % ѭ����ȡֱ���ﵽĿ����
        for d = 1:line_number
            line = fgets(fileID);
            if ~ischar(line)
                error('�����ļ���β���޷���ȡָ����');
            end
        end
        
        % �ر��ļ�
        fclose(fileID);
        
        % ʹ�ö��ŷָ��һ�е�����
        C = strsplit(line, ',');
        
        % ��ȡ��һ���ֶε�����
        first_field_str = strtrim(C{2}); % �Ƴ���β�ո�
        numeric_value_str = regexp(first_field_str, '[-+]?[0-9]*\.?[0-9]+', 'match');
        if ~isempty(numeric_value_str)
            numeric_value = str2double(numeric_value_str); % ת��Ϊ����
            
            % ������ֺ������ "u"������� 0.001
            if endsWith(first_field_str, 'u')
                numeric_value = numeric_value * 0.000001;
            end
            
            if endsWith(first_field_str, 'm')
                numeric_value = numeric_value * 0.001;
            end
            
            if endsWith(first_field_str, 'n')
                numeric_value = numeric_value * (10^(-9));
            end
            
            if endsWith(first_field_str, 'k')
                numeric_value = numeric_value * (10^(3));
            end

            % ��ʾ���
            G(m1,m2)=numeric_value;
        end
        
        first_field_str = strtrim(C{3}); % �Ƴ���β�ո�
        numeric_value_str = regexp(first_field_str, '[-+]?[0-9]*\.?[0-9]+', 'match');
        if ~isempty(numeric_value_str)
            numeric_value = str2double(numeric_value_str); % ת��Ϊ����
            G(m1,m2)=G(m1,m2)*exp(1i*numeric_value);
            exp(1i*numeric_value)
        end
        
    end
end

% ����������G�������н���

% ԭʼ����
data =linspace(1,m,m);

% ʹ��ð���������Զ���ıȽϹ�������
n = length(data);
for i = 1:n
    for j = 1:n-1
        if custom_compare(data(j+1), data(j))
            % ����λ��
            temp = data(j+1);
            data(j+1) = data(j);
            data(j) = temp;
        end
    end
end
[a,data]=sort(data);
G1=G(:,data);

H=-inv(G1.')/(1i*(10^5))-(1/(10^(-10)*10)+10);
H1=G.*conj(G);
% surf(G(1:9,:).*conj(G(1:9,:)));
% surf(G1.*conj(G1));
surf(H.*conj(H));

%����ǱȽϺ���
function result = custom_compare(x, y)
    str_x = num2str(x);
    str_y = num2str(y);
    len_x = length(str_x);
    len_y = length(str_y);
    
    % ��λ�Ƚ�
    for i = 1:min(len_x, len_y)
        if str_x(i) ~= str_y(i)
            result = str_x(i) < str_y(i);
            return;
        end
    end
    
    % ���ǰ���λ������ͬ���������ֳ��Ƚ��бȽ�
    result = len_x < len_y;
end