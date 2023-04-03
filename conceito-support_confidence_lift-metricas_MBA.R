# Definições: Support, Confidence e Lift


'''

    A Análise de Cesta de Compras (Market Basket Analysis) é uma das principais técnicas usados por grandes varejistas para
descobrir associações entre itens. A técnica funciona procurando combinações de itens que ocorrem juntos com frequência nas
transações. Em outras palavras, permite que os varejistas identifiquem as relações entre os itens que as pessoas compram.

    São usadas 3 métricas (medidas que permitem avaliar a eficácia de um modelo ou algoritmo em termos quantitativos) principais
para analisar o resultado do algoritmo Apriori, o mais usado em MBA.

    "Apriori" é um algoritmo de mineração de regras de associação utilizado em aprendizado de máquina para identificar padrões 
frequentes em conjuntos de dados. Ele é comumente utilizado em análise de cestas de compras, detecção de fraudes em cartões de
crédito e outras aplicações que envolvem identificação de associações entre itens. As regras de associação identificadas pelo algoritmo
Apriori são expressas em termos de "antecedentes" e "consequentes", onde o antecedente é uma combinação de itens que ocorre frequentemente
na base de dados e o consequente é um item ou um conjunto de itens que pode estar relacionado ao antecedente. As regras de associação
são avaliadas com base em diversas métricas, como suporte, confiança e lift.


- Support    =    Fração de transações que contém X e Y. O support nos diz o quão popular é um item (ou conjunto de itens),
                  conforme medido pela proporção de transações nas quais o item (ou conjunto de itens) aparece.
            
            
                                 Transactions containing both X and Y  
            Support({X}->{Y}) = ______________________________________
                                   Total number of transactions
            
            
            
            
- Confidence  =   A confidence nos diz a probabilidade de compra do item Y quando o item X é comprado, expresso como {X->Y}.

        
                                    Transactions containing both X and Y  
            Confidence({X}->{Y}) = _______________________________________
                                         Transactions containing X
                                      


Lift          =    Esta métrica indica quanto aumentou nossa confiança de que Y será comprado, dado que X foi comprado.



                              (Transactions containing both X and Y) / (Transactions containing X)  
            Lift({X}->{Y}) = ______________________________________________________________________
                                         Fraction of transactions containing Y
                                         
                                         


- O parâmetro minlen do algoritimo Apriori em R indica o comprimento mínimo da regra (por exemplo 3 itens se o parâmetro for igual a 3).                                         
                                    





'''